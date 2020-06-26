<a href="https://githubsfdeploy.herokuapp.com">
  <img alt="Deploy to Salesforce"
       src="https://raw.githubusercontent.com/afawcett/githubsfdeploy/master/deploy.png">
</a>

# JSONObjectPlainer
Transform SObject object with parent relationships to plain JSON object.
Was developed to simplify data binding for lighting-datatable lwc component.
Lighting-datatable doesn't support column field name with relation object like:
```
{
  
  Id: "0QL5000000380hoGAA",
  Product2: {
    Description: "Description"
    Id: "01t50000003A1QvAAK"
    Name: "MSB7890-ES2F"
  },
  Product2Id: "01t50000003A1QvAAK",
  Quantity: 1
}
```
this class transform it to:
```
{
  Id: "0QL5000000380hoGAA",
  Product2.Description: "Description",
  Product2.Id: "01t50000003A1QvAAK",
  Product2.Name: "MSB7890-ES2F",
  Product2Id: "01t50000003A1QvAAK",
  Quantity: 1
}
```

### How to use
JSONObjectPlainer.plain() accepts List of SObjects or single record as well.
```
@AuraEnabled(cacheable=true)
public static List<Object> getItems(Id quoteId){
    List<QuoteLineItem> items = [
        SELECT Product2.Name, Product2.Description, Quantity
        FROM QuoteLineItem
        WHERE QuoteId = :quoteId
    ];
    return JSONObjectPlainer.plain(items);
}
```