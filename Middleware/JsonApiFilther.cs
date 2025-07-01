using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Filters;
using System.Reflection;

namespace TMSCore.Middlewares;
public class JsonApiFilter : ActionFilterAttribute
{
    // Set of fields that should go in meta instead of attributes
    private static readonly HashSet<string> MetaFields = new(StringComparer.OrdinalIgnoreCase)
    {
        "CreateDate",
        "CreateUserId",
        "UpdateDate",
        "UpdateUserId",
        "Sort"
    };

    public override void OnActionExecuted(ActionExecutedContext context)
    {
        if (context.Result is ObjectResult objectResult && objectResult.Value != null)
        {
            var responseObject = objectResult.Value;
            var request = context.HttpContext.Request;

            // Parse fields query parameter (for attribute selection)
            HashSet<string>? fields = ParseQueryParameter(request.Query["fields"]);

            // Parse includes query parameter (for including related resources)
            HashSet<string>? includes = ParseQueryParameter(request.Query["include"]);

            // Handle collections
            if (responseObject is System.Collections.IEnumerable collection &&
                responseObject.GetType() != typeof(string))
            {
                HandleCollection(context, objectResult, collection, fields, includes);
                return;
            }

            // Handle single objects
            HandleSingleObject(context, objectResult, responseObject, fields, includes);
        }

        base.OnActionExecuted(context);
    }

    private HashSet<string>? ParseQueryParameter(string query)
    {
        if (string.IsNullOrWhiteSpace(query))
            return null;

        return new HashSet<string>(
            query.Split(',').Select(p => p.Trim()),
            StringComparer.OrdinalIgnoreCase);
    }

    private void HandleSingleObject(
        ActionExecutedContext context,
        ObjectResult objectResult,
        object responseObject,
        HashSet<string>? fields,
        HashSet<string>? includes)
    {
        // Extract type name
        var typeName = GetResourceTypeName(responseObject.GetType());

        // Extract ID using our custom function that prioritizes specific primary keys
        string id = GetResourceId(responseObject);

        // Extract attributes with optional field filtering (excluding meta fields)
        var attributes = GetFilteredAttributes(responseObject, fields);

        // Extract meta information (timestamps, sort order, etc.)
        var meta = GetMetaFields(responseObject, fields);

        // Extract relationships
        var relationships = GetFilteredRelationships(responseObject, fields, includes);

        // Collect included resources if requested
        var included = includes != null && includes.Any()
            ? GetIncludedResources(responseObject, includes)
            : null;

        // Create resource object
        var resourceObject = new
        {
            type = typeName,
            id,
            attributes,
            relationships = relationships.Count > 0 ? relationships : null,
            meta = meta.Count > 0 ? meta : null
        };

        // Create JSON:API response with optional included resources
        var response = new
        {
            data = resourceObject,
            included = (included != null && included.Any()) ? included : null
        };

        context.Result = new ObjectResult(response) { StatusCode = objectResult.StatusCode };
    }

    private void HandleCollection(
        ActionExecutedContext context,
        ObjectResult objectResult,
        System.Collections.IEnumerable collection,
        HashSet<string>? fields,
        HashSet<string>? includes)
    {
        var items = collection.Cast<object>().ToList();
        if (!items.Any())
        {
            // Handle empty collection
            context.Result = new ObjectResult(new { data = new object[] { } })
            {
                StatusCode = objectResult.StatusCode
            };
            return;
        }

        var data = items.Select(item =>
        {
            var typeName = GetResourceTypeName(item.GetType());
            string id = GetResourceId(item);

            // Extract attributes with optional field filtering (excluding meta fields)
            var attributes = GetFilteredAttributes(item, fields);

            // Extract meta information (timestamps, sort order, etc.)
            var meta = GetMetaFields(item, fields);

            // Extract relationships
            var relationships = GetFilteredRelationships(item, fields, includes);

            // Create resource object with relationships
            return new
            {
                type = typeName,
                id,
                attributes,
                relationships = relationships.Count > 0 ? relationships : null,
                meta = meta.Count > 0 ? meta : null
            };
        }).ToArray();

        // Collect included resources for all items if requested
        var included = includes != null && includes.Any()
            ? items.SelectMany(item => GetIncludedResources(item, includes)).ToList()
            : null;

        // Create JSON:API response with optional included resources
        var response = new
        {
            data,
            included = (included != null && included.Any()) ? included : null
        };

        context.Result = new ObjectResult(response) { StatusCode = objectResult.StatusCode };
    }

    private Dictionary<string, object?> GetFilteredAttributes(object item, HashSet<string>? fields)
    {
        var properties = item.GetType()
            .GetProperties(BindingFlags.Public | BindingFlags.Instance)
            .Where(p => !IsIdProperty(p) && !IsComplexType(p.PropertyType) && !IsMetaField(p));

        // Apply fields filter if provided
        if (fields != null && fields.Any())
        {
            properties = properties.Where(p =>
                fields.Contains(p.Name) ||
                fields.Contains(ToCamelCase(p.Name)));
        }

        return properties.ToDictionary(p => ToCamelCase(p.Name), p => p.GetValue(item));
    }

    private Dictionary<string, object?> GetMetaFields(object item, HashSet<string>? fields)
    {
        var properties = item.GetType()
            .GetProperties(BindingFlags.Public | BindingFlags.Instance)
            .Where(p => IsMetaField(p));

        // Apply fields filter if provided
        if (fields != null && fields.Any())
        {
            properties = properties.Where(p =>
                fields.Contains(p.Name) ||
                fields.Contains(ToCamelCase(p.Name)));
        }

        return properties.ToDictionary(p => ToCamelCase(p.Name), p => p.GetValue(item));
    }

    private bool IsMetaField(PropertyInfo prop)
    {
        return MetaFields.Contains(prop.Name);
    }

    private Dictionary<string, object?> GetFilteredRelationships(
        object item,
        HashSet<string>? fields,
        HashSet<string>? includes)
    {
        var relationships = new Dictionary<string, object?>();

        var properties = item.GetType()
            .GetProperties(BindingFlags.Public | BindingFlags.Instance)
            .Where(p => IsComplexType(p.PropertyType) && p.PropertyType != typeof(string));

        // Apply field filtering to relationships if needed
        if (fields != null && fields.Any())
        {
            properties = properties.Where(p =>
                fields.Contains(p.Name) ||
                fields.Contains(ToCamelCase(p.Name)));
        }

        foreach (var prop in properties)
        {
            var relatedEntity = prop.GetValue(item);
            var relationshipName = ToCamelCase(prop.Name);

            // Skip relationship if not in includes (optional)
            if (includes != null && includes.Any() &&
                !includes.Contains(relationshipName) &&
                !includes.Contains(prop.Name))
            {
                continue;
            }

            // Allow null relationships (improvement #3)
            if (relatedEntity == null)
            {
                relationships.Add(relationshipName, new { data = (object?)null });
                continue;
            }

            if (relatedEntity is System.Collections.IEnumerable relatedCollection)
            {
                var relationshipData = relatedCollection.Cast<object>()
                    .Select(rel => new
                    {
                        type = GetResourceTypeName(rel.GetType()),
                        id = GetResourceId(rel)
                    })
                    .ToList();

                // Simplified relationships structure (improvement #4)
                relationships.Add(relationshipName, new { data = relationshipData });
            }
            else
            {
                // Simplified relationships structure (improvement #4)
                relationships.Add(relationshipName, new
                {
                    data = new
                    {
                        type = GetResourceTypeName(relatedEntity.GetType()),
                        id = GetResourceId(relatedEntity)
                    }
                });
            }
        }

        return relationships;
    }

    private List<object> GetIncludedResources(object item, HashSet<string> includes)
    {
        var includedResources = new List<object>();
        var processedResources = new HashSet<string>(); // Prevent duplicate includes

        foreach (var prop in item.GetType()
            .GetProperties(BindingFlags.Public | BindingFlags.Instance)
            .Where(p => IsComplexType(p.PropertyType) && p.PropertyType != typeof(string)))
        {
            var relatedEntity = prop.GetValue(item);
            if (relatedEntity == null) continue;

            var relationshipName = ToCamelCase(prop.Name);

            // Check if this relationship should be included
            if (!includes.Contains(relationshipName) && !includes.Contains(prop.Name))
                continue;

            if (relatedEntity is System.Collections.IEnumerable relatedCollection)
            {
                foreach (var relatedItem in relatedCollection)
                {
                    if (relatedItem == null) continue;

                    // Create resource identifier
                    var type = GetResourceTypeName(relatedItem.GetType());
                    var id = GetResourceId(relatedItem);
                    var resourceKey = $"{type}:{id}";

                    // Skip if this resource has already been included
                    if (processedResources.Contains(resourceKey))
                        continue;

                    processedResources.Add(resourceKey);

                    // Extract attributes and meta for included resource
                    var attributes = GetFilteredAttributes(relatedItem, null);
                    var meta = GetMetaFields(relatedItem, null);
                    var relationships = GetFilteredRelationships(relatedItem, null, null);

                    // Add each related item to included resources
                    includedResources.Add(new
                    {
                        type,
                        id,
                        attributes,
                        relationships = relationships.Count > 0 ? relationships : null,
                        meta = meta.Count > 0 ? meta : null
                    });
                }
            }
            else
            {
                // Create resource identifier
                var type = GetResourceTypeName(relatedEntity.GetType());
                var id = GetResourceId(relatedEntity);
                var resourceKey = $"{type}:{id}";

                // Skip if this resource has already been included
                if (processedResources.Contains(resourceKey))
                    continue;

                processedResources.Add(resourceKey);

                // Extract attributes and meta for included resource
                var attributes = GetFilteredAttributes(relatedEntity, null);
                var meta = GetMetaFields(relatedEntity, null);
                var relationships = GetFilteredRelationships(relatedEntity, null, null);

                // Add single related item to included resources
                includedResources.Add(new
                {
                    type,
                    id,
                    attributes,
                    relationships = relationships.Count > 0 ? relationships : null,
                    meta = meta.Count > 0 ? meta : null
                });
            }
        }

        return includedResources;
    }

    private string GetResourceId(object resource)
    {
        var type = resource.GetType();

        // Check for properties with [Key] attribute first
        var keyProperty = type.GetProperties()
            .FirstOrDefault(p => p.GetCustomAttributes(typeof(System.ComponentModel.DataAnnotations.KeyAttribute), true).Any());

        if (keyProperty != null)
        {
            return keyProperty.GetValue(resource)?.ToString() ?? Guid.NewGuid().ToString();
        }

        // Try specific primary key patterns first - using the entity name pattern
        var typeName = type.Name.Replace("Model", "");
        var specificIdPropertyName = $"{typeName}Id";
        var specificIdProperty = type.GetProperty(specificIdPropertyName);
        if (specificIdProperty != null)
        {
            return specificIdProperty.GetValue(resource)?.ToString() ?? Guid.NewGuid().ToString();
        }

        // Also check for PrimaryKey or EntityId patterns
        var otherIdPatterns = new[]
        {
        type.GetProperty($"{typeName}PK"),
        type.GetProperty("PrimaryKey"),
        type.GetProperty("EntityId")
    }.Where(p => p != null).FirstOrDefault();

        if (otherIdPatterns != null)
        {
            return otherIdPatterns.GetValue(resource)?.ToString() ?? Guid.NewGuid().ToString();
        }

        // Fall back to standard ID properties
        var idProperty = type.GetProperty("Id") ?? type.GetProperty("id");
        if (idProperty != null)
        {
            return idProperty.GetValue(resource)?.ToString() ?? Guid.NewGuid().ToString();
        }

        // Last resort - generate a UUID
        return Guid.NewGuid().ToString();
    }

    private bool IsIdProperty(PropertyInfo prop)
    {
        var typeName = prop.DeclaringType?.Name.Replace("Model", "");
        var name = prop.Name;

        return name == "Id" ||
               name == "id" ||
               name == $"{typeName}Id" ||
               name == $"{typeName}PK" ||
               name == "PrimaryKey" ||
               name == "EntityId";
    }

    private string GetResourceTypeName(Type type)
    {
        // Convert PascalCase type name to kebab-case for JSON:API
        var typeName = type.Name.Replace("Model", "").ToLower();
        return typeName;
    }

    private bool IsComplexType(Type type)
    {
        return type != typeof(string) &&
              (type.IsClass ||
               type.IsInterface ||
               (type.IsGenericType &&
                (type.GetGenericTypeDefinition() == typeof(ICollection<>) ||
                 type.GetGenericTypeDefinition() == typeof(IEnumerable<>) ||
                 type.GetGenericTypeDefinition() == typeof(List<>))));
    }

    private string ToCamelCase(string name)
    {
        if (string.IsNullOrEmpty(name) || !char.IsUpper(name[0]))
            return name;

        return char.ToLower(name[0]) + name.Substring(1);
    }
}