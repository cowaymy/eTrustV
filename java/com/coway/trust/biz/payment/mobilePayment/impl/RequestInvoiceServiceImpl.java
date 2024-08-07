package com.coway.trust.biz.payment.mobilePayment.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.poi.util.StringUtil;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.common.MobileAppTicketApiCommonService;
import com.coway.trust.biz.payment.mobilePayment.RequestInvoiceService;
import com.coway.trust.biz.scm.impl.ScmMasterManagementServiceImpl;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.cmmn.model.BulkSmsVO;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.util.CommonUtils;
import com.fasterxml.jackson.core.JsonParseException;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.sun.jersey.api.client.Client;
import com.sun.jersey.api.client.ClientResponse;
import com.sun.jersey.api.client.WebResource;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import org.apache.http.*;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.ContentType;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClientBuilder;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : InvoiceApiServiceImpl.java
 * @Description : TO-DO Class Description
 *
 * @History
 * <pre>
 * Date             Author          Description
 * -------------    -----------     -------------
 * 2019. 09. 27.    KR-JAEMJAEM:)   First creation
 * </pre>
 */
@Service("RequestInvoiceService")
public class RequestInvoiceServiceImpl extends EgovAbstractServiceImpl implements RequestInvoiceService{
	private static final Logger LOGGER = LoggerFactory.getLogger(RequestInvoiceServiceImpl.class);

	@Resource(name = "RequestInvoiceMapper")
	private RequestInvoiceMapper requestInvoiceMapper;



    @Resource(name = "mobileAppTicketApiCommonService")
    private MobileAppTicketApiCommonService mobileAppTicketApiCommonService;



	@Override
	public List<EgovMap> selectTicketStatusCode() throws Exception{
	    return requestInvoiceMapper.selectTicketStatusCode();
	}



	@Override
	public List<EgovMap> selectInvoiceType() throws Exception{
	    return requestInvoiceMapper.selectInvoiceType();
	}



    @Override
    public ReturnMessage selectRequestInvoiceList(Map<String, Object> param) throws Exception{
        ReturnMessage result = new ReturnMessage();
        int total = requestInvoiceMapper.selectRequestInvoiceCount(param);
        result.setTotal(total);
        result.setDataList(requestInvoiceMapper.selectRequestInvoiceList(param));
        return result;
    }



    @Override
	public int saveRequestInvoiceArrpove(Map<String, Object> param, int userId) throws Exception {
    	boolean apiresult = false;
    	int saveCnt = 0 ;

		param.put("userId", userId);
		if (StringUtils.isEmpty(param.get("reqInvcNo"))) {
			throw new ApplicationException(AppConstants.FAIL, "Please check the Request Number value.");
		}
		if (StringUtils.isEmpty(param.get("reqStusId"))) {
			throw new ApplicationException(AppConstants.FAIL, "Please check the Request Status value.");
		}
		if (StringUtils.isEmpty(param.get("userId"))) {
			throw new ApplicationException(AppConstants.FAIL, "Please check the User Id value.");
		}
		if (StringUtils.isEmpty(param.get("mobTicketNo"))) {
			throw new ApplicationException(AppConstants.FAIL, "Please check the User Id value.");
		}

		LOGGER.debug("saveRequestInvoiceArrpove : {}", param.toString());

		if (param.get("taxInvcId") != null) {
			LOGGER.debug("param.get(taxInvcId) != null ");
			apiresult = sendMobileInvoiceRequest(param);
		}
		LOGGER.debug("apiresult "+apiresult);

		if (apiresult) {
			saveCnt = requestInvoiceMapper.saveRequestInvoiceArrpove(param);
			if (saveCnt == 0) {
				throw new ApplicationException(AppConstants.FAIL, "Failed to save Request Invoive.");
			}

			List<Map<String, Object>> arrParams = new ArrayList<Map<String, Object>>();
			Map<String, Object> sParams = new HashMap<String, Object>();
			sParams.put("mobTicketNo", param.get("mobTicketNo"));
			sParams.put("ticketStusId", "5");
			sParams.put("userId", userId);
			arrParams.add(sParams);

			saveCnt = mobileAppTicketApiCommonService.updateMobileAppTicket(arrParams);
			if (saveCnt == 0) {
				throw new ApplicationException(AppConstants.FAIL, "Failed to update Mobile App Ticket.");
			}
		} else {
			saveCnt = 0;
			throw new ApplicationException(AppConstants.FAIL, "Failed to send Mobile Invoice Request.");
		}

		return saveCnt;
	}



    @Override
    public int saveRequestInvoiceReject(Map<String, Object> param, int userId) throws Exception{
        param.put("userId", userId);
        if( StringUtils.isEmpty( param.get("reqInvcNo") )){
            throw new ApplicationException(AppConstants.FAIL, "Please check the Request Number value.");
        }
        if( StringUtils.isEmpty( param.get("reqStusId") )){
            throw new ApplicationException(AppConstants.FAIL, "Please check the Request Status value.");
        }
        if( StringUtils.isEmpty( param.get("userId") )){
            throw new ApplicationException(AppConstants.FAIL, "Please check the User Id value.");
        }
        if( StringUtils.isEmpty( param.get("rem") )){
            throw new ApplicationException(AppConstants.FAIL, "Reject reason value does not exist.");
        }
        if( StringUtil.getEncodedSize(String.valueOf(param.get("rem"))) > 4000 ){
            throw new ApplicationException(AppConstants.FAIL, "Reject reason is too long.");
        }

        int saveCnt = requestInvoiceMapper.saveRequestInvoiceReject(param);
        if( saveCnt == 0 ){
            throw new ApplicationException(AppConstants.FAIL, "Failed to save.");
        }

        List<Map<String, Object>> arrParams  = new ArrayList<Map<String,Object>>();
        Map<String, Object> sParams = new HashMap<String, Object>();
        sParams.put("mobTicketNo", param.get("mobTicketNo"));
        sParams.put("ticketStusId", "6");
        sParams.put("userId", userId);
        arrParams.add(sParams);
        saveCnt = mobileAppTicketApiCommonService.updateMobileAppTicket(arrParams);
        if( saveCnt == 0 ){
            throw new ApplicationException(AppConstants.FAIL, "Failed to update.");
        }
        return saveCnt;
    }

	private boolean sendMobileInvoiceRequest(Map<String, Object> param) throws JsonParseException, JsonMappingException, IOException, JSONException {
		boolean result = false;

		LOGGER.debug("sendMobileInvoiceRequest : {}", param.toString());

		List<EgovMap> selectInvoiceDetails = requestInvoiceMapper.selectInvoiceDetails(param);

		LOGGER.debug("selectInvoiceDetails : {}", selectInvoiceDetails);

		JSONObject jsonObj = new JSONObject();
		JSONArray jarray = new JSONArray();

		jarray.put(new JSONObject().put("invoiceId", "65101018")
				.put("customerName","OCBC BANK (MALAYSIA) BERHAD")
				.put("customerEmail", "vannie.koh@coway.com.my")
				.put("invoiceDate", "MAY-20")
				.put("currentCharges", "RM 159.00")
				.put("previousBalance", "RM0.00")
				.put("outstanding", "RM 159.00")
				.put("virtualAccount", "98 9920 0001 0735")
				.put("invoiceNumber", "BR4137692522")
				.put("billerCode", "9928")
				.put("refNumber1", "36393064")
				.put("refNumbe2", "BR4137692522")
				.put("cowayEmail", "billing@coway.com.my"));

		jsonObj.put("data", jarray);

		LOGGER.debug("jsonObj " +jsonObj.toString());

		LOGGER.debug("jarray " +jarray.toString());

		String data = "{\"invoiceId\": \"65101018\",\r\n"
				+ " \"customerName\": \"OCBC BANK (MALAYSIA) BERHAD\",\r\n"
				+ " \"customerEmail\": \"vannie.koh@coway.com.my\",\r\n"
				+ " \"invoiceDate\": \"MAY-20\",\r\n"
				+ "	\"currentCharges\": \"RM 159.00\",\r\n"
				+ " \"previousBalance\": \"RM0.00\",\r\n"
				+ " \"outstanding\": \"RM 159.00\",\r\n"
				+ " \"virtualAccount\": \"98 9920 0001 0735\",\r\n"
				+ " \"invoiceNumber\": \"BR4137692522\",\r\n"
				+ " \"billerCode\": \"9928\",\r\n"
				+ " \"refNumber1\": \"36393064\",\r\n"
				+ " \"refNumber2\": \"BR4137692522\",\r\n"
				+ " \"cowayEmail\": \"billing@coway.com.my\""
				+ " \n}";

		LOGGER.debug("data " +data);

		StringEntity entity = new StringEntity(data);

		LOGGER.debug("entity " +entity);


		try (CloseableHttpClient client = HttpClientBuilder.create().build()) {

			HttpPost request = new HttpPost("http://128.199.165.110:8080/invoice/email");
			request.setHeader("Content-Type", "application/json; charset=utf8");
			request.setHeader("x-token", "fGxqeS9pzR7duRBV7xpXSkFBPtQFKn");

			request.setEntity(entity);

			HttpResponse response = client.execute(request);

			LOGGER.debug("client ", client);
			LOGGER.debug("request ", request);
			LOGGER.debug("response ", response);

			BufferedReader bufReader = new BufferedReader(new InputStreamReader(response.getEntity().getContent()));

			StringBuilder builder = new StringBuilder();

			String line;

			while ((line = bufReader.readLine()) != null) {

				builder.append(line);
				builder.append(System.lineSeparator());
			}

			LOGGER.debug("builder " + builder);

		} catch (IOException e) {

			e.printStackTrace();

		}

		/* below codes return HTTP ERROR CODE 403

		try {

	        URL url = new URL("http://128.199.165.110:8080/invoice/email&x-token=fGxqeS9pzR7duRBV7xpXSkFBPtQFKn");
	        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
	        conn.setDoOutput(true);
	        conn.setRequestMethod("POST");
	        conn.setRequestProperty("Content-Type", "application/json");
	        //conn.setRequestProperty("x-token", "fGxqeS9pzR7duRBV7xpXSkFBPtQFKn");

	        LOGGER.debug("url " +url);
	        LOGGER.debug("conn " +conn);

			String input = "{\n"
					+ " \"invoiceId\": \"65101018\",\r\n"
					+ " \"customerName\": \"OCBC BANK (MALAYSIA) BERHAD\",\r\n"
					+ " \"customerEmail\": \"vannie.koh@coway.com.my\",\r\n"
					+ " \"invoiceDate\": \"MAY 2020\",\r\n"
					+ "	\"currentCharges\": \"RM 159.00\",\r\n"
					+ " \"previousBalance\": \"RM0.00\",\r\n"
					+ " \"outstanding\": \"RM 159.00\",\r\n"
					+ " \"virtualAccount\": \"98 9920 0001 0735\",\r\n"
					+ " \"invoiceNumber\": \"BR4137692522\",\r\n"
					+ " \"billerCode\": \"9928\",\r\n"
					+ " \"refNumber1\": \"36393064\",\r\n"
					+ " \"refNumber2\": \"BR4137692522\",\r\n"
					+ " \"cowayEmail\": \"billing@coway.com.my\""
					+ " \n}";

	        LOGGER.debug("input " +input);

	        OutputStream os = conn.getOutputStream();
	        os.write(input.getBytes());
	        os.flush();

	        LOGGER.debug("conn.getResponseCode() " +conn.getResponseCode());

	        if (conn.getResponseCode() != HttpURLConnection.HTTP_CREATED) {
	            throw new RuntimeException("Failed : HTTP error code : "
	                + conn.getResponseCode());
	        }

	        BufferedReader br = new BufferedReader(new InputStreamReader(
	                (conn.getInputStream())));

	        String output;
	        LOGGER.debug("Output from Server .... \n");
	        while ((output = br.readLine()) != null) {
	        	LOGGER.debug(output);
	        }

	        conn.disconnect();

	      } catch (IOException e) {

	        e.printStackTrace();

	     } */
		return result;

    }



	private JSONObject getJsonObjectFromMap(List<EgovMap> selectInvoiceDetails) {
		// TODO Auto-generated method stub
		return null;
	}
}
