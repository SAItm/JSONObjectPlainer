public class JSONObjectPlainer {
    public static Object plain(Object obj) {
        return plainObject(obj, null);
    }

    public static List<Object> plain(List<Object> objs) {
        List<Object> result = new List<Object>();
        for (Object obj: objs) {
            result.add(plainObject(obj, null));
        }
        return result;
    }

    static Object plainObject(Object obj, String name) {
        List<Map<String, Object>> properties = new List<Map<String, Object>>();
        if (!(obj instanceof SObject)) {
            Map<String, Object> pair = new Map<String,Object> { name => obj };
            properties.add(pair);
            return (Object) properties;
        } else {
            Map<String, Object> objMap = ((SObject) obj).getPopulatedFieldsAsMap();
            for (String key: objMap.keySet()) {
                String field = String.isNotBlank(name) ? name + '.' + key : key;
                properties.addAll((List<Map<String, Object>>) plainObject(objMap.get(key), field));
            }
            if (String.isNotBlank(name)) {
                return properties;
            } else {
                Map<String, Object> finalObj = new Map<String, Object>();
                for (Map<String, Object> pair: properties){
                    String key = new List<String> (pair.keySet())[0];
                    Object value = pair.values()[0];
                    finalObj.put(key, value);
                }
                return finalObj;
            }
        }
    }
}