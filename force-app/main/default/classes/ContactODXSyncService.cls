public with sharing class ContactODXSyncService {

    public static HttpResponse fetchCases(Http http, String token, String firstName, String lastName, Date birthdate) {
        List<String> params = new List<String>{
                'first_name_param=' + EncodingUtil.urlEncode(firstName.toUpperCase(), 'UTF-8'),
                'last_name_param=' + EncodingUtil.urlEncode(lastName.toUpperCase(), 'UTF-8'),
                'birth_year=eq.' + birthdate.year(),
                'birth_month=eq.' + birthdate.month(),
                'record_type=eq.Party',
                'select=*,person_cases(id,record_id,record_type,odx_person_case_id,case_number,county,outstanding_fees,sentencing_date,counsel,case(filed_on,closed_on,judge,record_id),events(event_name,odx_event_category,judge,event_at,record_id),offenses(clean_offense,as_entered,record_id,offense_on),warrants(warrant_subtype,issue_date,closed_date,record_id),sentences(sentencing_date,end_date,is_suspended,is_deferred,record_id))'
        };

        HttpRequest req = new HttpRequest();
        req.setEndpoint(
                'https://oscn-api-3a5bc4ad266a.herokuapp.com/rpc/person_records_by_levenstein_names?' +
                        String.join(params, '&')
        );
        req.setMethod('GET');
        req.setHeader('Authorization', 'Bearer ' + token);
        req.setHeader('Content-Type', 'application/json');
        req.setTimeout(120000);

        HttpResponse res = http.send(req);
        System.debug('SYNC: fetchCases ' + res.getStatusCode() + ' ' + res.getStatus());
        return (res.getStatusCode() == 200 && !String.isBlank(res.getBody())) ? res : null;
    }
}