package com.coway.trust.biz.payment.govEInvoice.service.impl;

import java.text.SimpleDateFormat;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.annotation.Resource;
import javax.sql.rowset.serial.SerialBlob;
import javax.sql.rowset.serial.SerialClob;

import org.apache.commons.codec.binary.Base64;
import org.apache.commons.lang3.time.StopWatch;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.application.impl.FileApplicationImpl;
import com.coway.trust.biz.payment.billing.service.impl.SrvMembershipBillingMapper;
import com.coway.trust.biz.payment.govEInvoice.service.GovEInvcCheckStatusResponseVO;
import com.coway.trust.biz.payment.govEInvoice.service.GovEInvcDocumentVO;
import com.coway.trust.biz.payment.govEInvoice.service.GovEInvcDocumentVO.DocumentVO;
import com.coway.trust.biz.payment.govEInvoice.service.GovEInvcGenerateResponseVO.DocumentResponses;
import com.coway.trust.biz.payment.govEInvoice.service.GovEInvcGenerateResponseVO.ErrorDetails;
import com.coway.trust.biz.payment.govEInvoice.service.GovEInvcLineVO;
import com.coway.trust.biz.payment.govEInvoice.service.GovEInvcGenerateResponseVO;
import com.coway.trust.biz.payment.govEInvoice.service.GovEInvcVO;
import com.coway.trust.biz.payment.govEInvoice.service.GovEInvoiceService;
import com.coway.trust.biz.payment.invoice.service.InvoiceService;
import com.coway.trust.biz.payment.invoice.service.impl.InvoiceMapper;
import com.coway.trust.config.datasource.DataSource;
import com.coway.trust.config.datasource.DataSourceType;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.PropertyNamingStrategy;
import com.google.gson.Gson;

import java.io.BufferedReader;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.Reader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.sql.Blob;
import java.sql.Clob;
import java.sql.SQLException;
import java.text.ParseException;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;
import oracle.sql.BLOB;

/**
 * @Class Name : EgovSampleServiceImpl.java
 * @Description : Sample Business Implement Class
 * @Modification Information
 * @ @ 수정일 수정자 수정내용 @ --------- --------- ------------------------------- @ 2009.03.16 최초생성
 *
 * @author 개발프레임웍크 실행환경 개발팀
 * @since 2009. 03.16
 * @version 1.0
 * @see
 *
 * 	 Copyright (C) by MOPAS All right reserved.
 */

@Service("govEInvoiceService")
public class GovEInvoiceServiceImpl  implements GovEInvoiceService {

    private static final Logger LOGGER = LoggerFactory.getLogger(GovEInvoiceServiceImpl.class);

    @Resource(name = "govEInvoiceMapper")
    private GovEInvoiceMapper govEInvoiceMapper;

    @Value("${cleartax.api.key}")
    private String ClearTaxApiKey;

    @Value("${cleartax.api.value}")
    private String ClearTaxApiValue;

    @Value("${cleartax.api.url.domains}")
    private String ClearTaxApiDomain;

    @Value("${cleartax.api.url.generate}")
    private String ClearTaxApiGenerate;

    @Value("${cleartax.api.url.checkStatus}")
    private String ClearTaxApiChkSts;

    @Value("${cleartax.api.tin}")
    private String ClearTaxApiTin;

    @Override
    public List<EgovMap> selectGovEInvoiceList(Map<String, Object> params) {
        return govEInvoiceMapper.selectGovEInvoiceList(params);
    }

    @Override
    public EgovMap selectGovEInvoiceMain(Map<String, Object> params) {
        return govEInvoiceMapper.selectGovEInvoiceMain(params);
    }

    @Override
      public List<EgovMap> selectEInvStat(Map<String, Object> param) {
        return govEInvoiceMapper.selectEInvStat(param);
      }

    @Override
    public List<EgovMap> selectEInvCommonCode(Map<String, Object> param) {
        return govEInvoiceMapper.selectEInvCommonCode(param);
    }

    @Override
    public List<EgovMap> selectGovEInvoiceDetail(Map<String, Object> params) {
        return govEInvoiceMapper.selectGovEInvoiceDetail(params);
    }

    @Override
    public Map<String, Object> createEInvClaim(Map<String, Object> params) {
        return govEInvoiceMapper.createEInvClaim(params);
    }

    @Override
    public Map<String, Object> createEInvClaimDaily(Map<String, Object> params) {
    	return govEInvoiceMapper.createEInvClaimDaily(params);
    }

    @Override
    public int saveEInvDeactivateBatch(Map<String, Object> params) {
    	params.put("status", "21");
        int result = govEInvoiceMapper.saveEInvBatchMain(params);
        int result1 = govEInvoiceMapper.saveEInvDeactivateBatchEInv(params);
        return result;
    }

    @Override
    public int saveEInvBatch(Map<String, Object> params) {
    	params.put("batchStatus", 1);
        params.put("userId", 349);
    	int result = govEInvoiceMapper.saveEInvConfirmBatch(params);
    	return result;
    }

    @Override
    public Map<String, Object> prepareEInvClaim(Map<String, Object> params) {
        Map<String, Object> resultValue = new HashMap<String, Object>();

        List<Map<String, Object>> eInvcClaimList = new ArrayList<>();
        params.put("batchStatus", 5);
        params.put("einvStatus", 1);
        params.put("userId", 349);
        eInvcClaimList = govEInvoiceMapper.selectEInvSendList(params);

        Calendar calNow = Calendar.getInstance();
        Date currentDate = calNow.getTime();
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
        String formattedDate = dateFormat.format(currentDate);

        for(int i =0; i < eInvcClaimList.size(); i ++){
        	try{
                Map<String, Object> govEinvcMain = new HashMap<String, Object>();
                GovEInvcVO govEInvc = new GovEInvcVO();
                govEinvcMain = eInvcClaimList.get(i);
                govEinvcMain.put("issueDate", formattedDate);
                govEinvcMain.put("issueTime", "00:00:00");
                govEInvc.Invoice(govEinvcMain);

                List<GovEInvcLineVO> invoiceLine = new ArrayList<>();
                List<Map<String, Object>> eInvcClaimLineList = new ArrayList<>();
                Map<String, Object> lineParams = new HashMap<String, Object>();
                lineParams.put("invId", eInvcClaimList.get(i).get("invId").toString());
                lineParams.put("batchId", eInvcClaimList.get(i).get("batchId").toString());
                eInvcClaimLineList = govEInvoiceMapper.selectEInvLineSendList(lineParams);
                for(int j=0; j < eInvcClaimLineList.size() ;j++){
                    GovEInvcLineVO govEInvcLine = new GovEInvcLineVO();
                    govEInvcLine.InvoiceLine(eInvcClaimLineList.get(j));
                    invoiceLine.add(govEInvcLine);
                }
                govEInvc.setInvoiceLine(invoiceLine);

                String json = "";
                try {
                    ObjectMapper objectMapper = new ObjectMapper();
                    objectMapper.setPropertyNamingStrategy(PropertyNamingStrategy.UPPER_CAMEL_CASE);
                    json = objectMapper.writeValueAsString(govEInvc);
                    System.out.println(json);
                } catch (Exception e) {
                    e.printStackTrace();
                }

                Map<String, Object> jsonParams = new HashMap<String, Object>();
                jsonParams.put("jsonString", json);
                jsonParams.put("invId", eInvcClaimList.get(i).get("invId").toString());
                jsonParams.put("batchId", eInvcClaimList.get(i).get("batchId").toString());
                jsonParams.put("userId", 349);
                jsonParams.put("status", 104);
                jsonParams.put("issueDt", formattedDate);
                updEInvJsonString(jsonParams);

            }catch (Exception e) {
                System.out.println(e.getMessage()); //catch to not rollback for previously all transactions
            }
        }

//        int result = govEInvoiceMapper.saveEInvConfirmBatch(params);
//        resultValue.put("status", "1");
        return resultValue;
    }

    @Transactional(propagation = Propagation.REQUIRES_NEW)
    @Override
    public int updEInvJsonString(Map<String, Object> params) {
        int result = govEInvoiceMapper.updEInvJsonString(params);
        return result;
    }

    @Override
    public Map<String, Object> sendEInvClaim(Map<String, Object> params) {
        Map<String, Object> resultValue = new HashMap<String, Object>();

        List<Map<String, Object>> eInvcClaimList = new ArrayList<>();
        params.put("batchStatus", 5);
        params.put("einvStatus", 104);
        eInvcClaimList = govEInvoiceMapper.selectEInvSendList(params);

        int j = 0;
        List<DocumentVO> documentVOList = new ArrayList();
        int groupId = govEInvoiceMapper.selectInvoiceGroupIdSeq();//first seq assign
        for(int i =0; i < eInvcClaimList.size(); i++){

                Map<String, Object> documentParams = new HashMap<String, Object>();
                Clob documentDataClob = (Clob) eInvcClaimList.get(i).get("jsonString");
                String jsonString = null;
                try {
                    // Convert the Blob to a String
                    jsonString = clobToString(documentDataClob);
                    System.out.println("Retrieved JSON String: " + jsonString);
                } catch (SQLException | IOException e) {
                    e.printStackTrace();
                }

                byte[] bytesEncoded = Base64.encodeBase64(jsonString.getBytes());
                System.out.println("encoded value is " + new String(bytesEncoded));

                String inputDate = eInvcClaimList.get(i).get("invprdStartDt").toString();
                SimpleDateFormat inputFormat = new SimpleDateFormat("yyyy-MM-dd");
                SimpleDateFormat outputFormat = new SimpleDateFormat("MM_yyyy");
                String formattedDate = "";
                try {
                    Date date = inputFormat.parse(inputDate);
                    formattedDate = outputFormat.format(date);
                    System.out.println("Formatted date: " + formattedDate);
                } catch (ParseException e) {
                    e.printStackTrace();
                }

                String invNo = eInvcClaimList.get(i).get("invRefNo").toString();
                DocumentVO documentVO = new DocumentVO();
                documentParams.put("documentData",new String(bytesEncoded));
                documentParams.put("format","JSON");
                documentParams.put("uin",eInvcClaimList.get(i).get("uniqueId").toString());
                documentParams.put("invNo",invNo);
                documentVO.Invoice(documentParams);

                documentVOList.add(documentVO);

                Map<String, Object> jsonParams = new HashMap<String, Object>();
                jsonParams.put("invId", eInvcClaimList.get(i).get("invId").toString());
                jsonParams.put("batchId", eInvcClaimList.get(i).get("batchId").toString());
                jsonParams.put("userId", 349);
                jsonParams.put("status", 44);
                jsonParams.put("groupId", groupId);
                updEInvJsonString(jsonParams);

                if(j==9 || i+1 == eInvcClaimList.size()){
                    GovEInvcDocumentVO govEInvcDocumentVO = new GovEInvcDocumentVO();
                    govEInvcDocumentVO.setDocuments(documentVOList);
                    govEInvcDocumentVO.setVersion("MY_GENERATE_UBL_2_1_V1");

                    String json = "";
                    try {
                        ObjectMapper objectMapper = new ObjectMapper();
                        objectMapper.setPropertyNamingStrategy(PropertyNamingStrategy.UPPER_CAMEL_CASE);
                        json = objectMapper.writeValueAsString(govEInvcDocumentVO);
                        System.out.println(json);

                        Map<String, Object> einvApiParams = new HashMap<String, Object>();
                        einvApiParams.put("cleartaxUrl", ClearTaxApiDomain + ClearTaxApiGenerate+"?einvoice-type=SALES");
                        einvApiParams.put("json", json);
                        einvApiParams.put("groupId", groupId);
                        //einvApiParams.put("uin", eInvcClaimList.get(i).get("uniqueId").toString());
                        clearTaxSubmitReqApi(einvApiParams);
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                    documentVOList = new ArrayList();
                    j=0;
                    if( i+1 != eInvcClaimList.size()){
                        groupId = govEInvoiceMapper.selectInvoiceGroupIdSeq();//subseq assign
                    }
                }else{
                    j++;
                }
        }

        Map<String, Object> updateParams = new HashMap<String, Object>();
        govEInvoiceMapper.updateEInvMain(updateParams);

        return resultValue;
    }

    private static String clobToString(Clob clob) throws SQLException, IOException {
        StringBuilder sb = new StringBuilder();
        Reader reader = clob.getCharacterStream();
        BufferedReader br = new BufferedReader(reader);

        String line;
        while ((line = br.readLine()) != null) {
            sb.append(line);
        }
        br.close();

        return sb.toString();
    }

    private static String blobToString(Blob blob) throws SQLException, IOException {
        // Get the binary stream from the Blob
        try (InputStream inputStream = blob.getBinaryStream();
             ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream()) {

            byte[] buffer = new byte[4096];
            int bytesRead;
            while ((bytesRead = inputStream.read(buffer)) != -1) {
                byteArrayOutputStream.write(buffer, 0, bytesRead);
            }

            // Convert the byte array to a String using UTF-8 encoding
            return new String(byteArrayOutputStream.toByteArray(), StandardCharsets.UTF_8);
        }
    }

    @Override
    public Map<String, Object> callEinvoiceApi(Map<String, Object> params) {
        Map<String, Object> resultValue = new HashMap<String, Object>();
        return resultValue;
    }

    @Override
    public Map<String, Object> clearTaxSubmitReqApi(Map<String, Object> params) {
        Map<String, Object> resultValue = new HashMap<String, Object>();
        resultValue.put("status", AppConstants.FAIL);
        resultValue.put("message", "Cleartax Failed: Please contact Administrator.");

        String respTm = null;
        String lmsApiUserId = "3";
        String key= ClearTaxApiKey;
        String value = ClearTaxApiValue;

        StopWatch stopWatch = new StopWatch();
        stopWatch.reset();
        stopWatch.start();

        String CleartaxUrl = params.get("cleartaxUrl").toString();
        String jsonString = params.get("json").toString();
        //String uin = params.get("uin").toString();
        String groupId = params.get("groupId").toString();
//		String einvType = params.get("einvoiceType").toString();
        String output1 = "";
        String ResponseCode = "Failed";
        String ResponseMsg = "";
        int respSeq = 0;
        GovEInvcGenerateResponseVO p = new GovEInvcGenerateResponseVO();
        try{
            URL url = new URL(CleartaxUrl);

            //insert to api0004m
            //
            LOGGER.error("Start Calling Cleartax API ...." + CleartaxUrl + "......\n");
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setDoOutput(true);
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Content-Type", "application/json");
            conn.setRequestProperty("x-clear-tin", ClearTaxApiTin);
            conn.setRequestProperty(ClearTaxApiKey, ClearTaxApiValue);
            OutputStream os = conn.getOutputStream();
            os.write(jsonString.getBytes());
            os.flush();

            LOGGER.error("Start Calling Cleartax API return......\n");
            LOGGER.error("Start Calling Cleartax API return" + conn.getResponseMessage() + "......\n");

            if (conn.getResponseCode() != HttpURLConnection.HTTP_BAD_REQUEST) {
                respSeq = govEInvoiceMapper.selectApiInvoiceSeq();
                BufferedReader br = new BufferedReader(new InputStreamReader(
                        (conn.getInputStream())));
                conn.getResponseMessage();

                String output = "";
                LOGGER.debug("Output from Server .... \n");
                while ((output = br.readLine()) != null) {
                    output1 = output;
                    LOGGER.debug(output);
                }

                Gson g = new Gson();
                p = g.fromJson(output1, GovEInvcGenerateResponseVO.class);

                //insert to overall response table
                //output1

//		        String msg = p.getDocumentResponses() != null ? "Cleartax: " + p.getErrorDetails().toString() : "";

                if(p.getDocumentResponses() != null){
                    ResponseCode = "Success";

                    List<DocumentResponses> documentResponseList = new ArrayList<>();
                    documentResponseList = p.getDocumentResponses();
                    for(int i = 0 ; i < documentResponseList.size(); i++){
                        DocumentResponses documentResponse = documentResponseList.get(i);
                        String responseUin = documentResponse.getUniqueId()==null?"":documentResponse.getUniqueId().toString();
                        String responseDocId = documentResponse.getDocumentId()==null?"":documentResponse.getDocumentId().toString();
                        String responseUuid = documentResponse.getUuid()==null?"":documentResponse.getUuid().toString();
                        String responseInternalId = documentResponse.getInternalId()==null?"":documentResponse.getInternalId().toString();
                        List<ErrorDetails> ErrorDetailsList= documentResponse.getErrorDetails();

                        Map<String, Object> apiDetparams = new HashMap<>();
                        apiDetparams.put("respId", respSeq);
                        apiDetparams.put("uin", responseUin);
                        apiDetparams.put("docId", responseDocId);
                        apiDetparams.put("uuid", responseUuid);
                        apiDetparams.put("internalId", responseInternalId);
                        ObjectMapper objectMapper = new ObjectMapper();
                        String errDetStr = objectMapper.writerWithDefaultPrettyPrinter().writeValueAsString(documentResponse.getErrorDetails()==null?"":documentResponse.getErrorDetails());
                        apiDetparams.put("errorDetails", errDetStr);
                        String warningDetStr = objectMapper.writerWithDefaultPrettyPrinter().writeValueAsString(documentResponse.getWarningDetails()==null?"":documentResponse.getWarningDetails());
                        apiDetparams.put("warningDetails", warningDetStr);
                        apiDetparams.put("respCode", documentResponse.getSuccess()==null?"":documentResponse.getSuccess().toString());

                        insertApiDetailAccessLog(apiDetparams);
                    }
                }
                /*if(p.getStatus() ==null || p.getStatus().isEmpty()){
                    p.setCode(String.valueOf(AppConstants.RESPONSE_CODE_INVALID));
                    resultValue.put("status", AppConstants.FAIL);
                    resultValue.put("message", msg);
                }else if(p.getStatus().equals("true")){
                    p.setCode(String.valueOf(AppConstants.RESPONSE_CODE_SUCCESS));
                    resultValue.put("status", AppConstants.SUCCESS);
                    resultValue.put("message", msg);
                }else{
                    resultValue.put("status", AppConstants.FAIL);
                    resultValue.put("message", msg);
                    p.setCode(String.valueOf(AppConstants.RESPONSE_CODE_INVALID));
                }*/
                conn.disconnect();

                br.close();
            }else{
                resultValue.put("status", AppConstants.FAIL);
                resultValue.put("message", "No Response");
//				p.setCode(String.valueOf(AppConstants.RESPONSE_CODE_INVALID));
//				p.setMessage("No Response");
            }
        }catch(Exception e){
            LOGGER.error("Timeout:");
            LOGGER.error("[CleartaxMemberListInsertUpdate] - Caught Exception: " + e);
            resultValue.put("status", AppConstants.RESPONSE_CODE_TIMEOUT);
            if(output1.equals("")){
                output1 = e.toString();
            }
//			p.setCode(String.valueOf(AppConstants.RESPONSE_CODE_TIMEOUT));
//			p.setStatus(String.valueOf(AppConstants.RESPONSE_CODE_TIMEOUT));
//			p.setMessage("Timeout " + e.toString());
        }finally{
            stopWatch.stop();
            respTm = stopWatch.toString();
            this.rtnRespMsg(respSeq, CleartaxUrl, ResponseCode, ResponseMsg,respTm , jsonString, output1 ,"1", groupId);
        }

        return resultValue;
    }

    @Transactional(propagation = Propagation.REQUIRES_NEW)
    @Override
    public int insertApiDetailAccessLog(Map<String, Object> params) {
        int result = govEInvoiceMapper.insertApiDetailAccessLog(params);
        return result;
    }

    @Transactional(propagation = Propagation.REQUIRES_NEW)
      @Override
      public Map<String, Object> rtnRespMsg(int respSeq, String pgmPath, String code, String msg, String respTm, String reqPrm, String respPrm, String apiUserId, String refNo) {

        EgovMap data = new EgovMap();
        Map<String, Object> params = new HashMap<>();

        params.put("respId", respSeq);
          params.put("respCde", code);
          params.put("errMsg", msg);
//	      Blob reqParamBlob;
//	      try {
//			reqParamBlob = createBlobFromString(reqPrm);
//			params.put("reqParam", reqParamBlob);
//	    	  Clob reqParamClob = new SerialClob(reqPrm.toCharArray());
//	    	  params.put("reqParam", reqParamClob);
//	      } catch (SQLException e) {
//			// TODO Auto-generated catch block
//			e.printStackTrace();
//	      }
          params.put("reqParam", reqPrm);
          params.put("ipAddr", "");
          params.put("prgPath", pgmPath != null ? pgmPath : " ");
          params.put("respTm", respTm);
          params.put("respParam", respPrm != null ? respPrm.toString().length() >= 4000 ? respPrm.toString().substring(0,4000) : respPrm.toString() : respPrm);
          params.put("apiUserId", apiUserId);
          params.put("refNo", refNo);

          govEInvoiceMapper.insertApiAccessLog(params);

//	      data.put("code", code);
//	      data.put("message", msg);
//	      data.put("status", (code.equals("200")||code.equals("201"))?AppConstants.DESC_SUCCESS:AppConstants.DESC_FAILED);
//	      if(respPrm != null && !respPrm.isEmpty()){
//	    	  data.put("data", respPrm);
//	      }

          return data;
      }

    private Blob createBlobFromString(String data) throws SQLException {
        if (data == null) {
            return null;
        }
        byte[] bytes = data.getBytes();  // Convert string to bytes
        return new javax.sql.rowset.serial.SerialBlob(bytes);  // Create Blob object
    }

    @Override
    public Map<String, Object> checkStatusEInvClaim(Map<String, Object> params) {
        Map<String, Object> resultValue = new HashMap<String, Object>();

        List<Map<String, Object>> eInvcClaimList = new ArrayList<>();
        params.put("einvStatus", 121);
        eInvcClaimList = govEInvoiceMapper.selectEInvSendList(params);

        for(int i =0; i < eInvcClaimList.size(); i++){
        	Map<String, Object> documentParams = new HashMap<String, Object>();
        	documentParams = eInvcClaimList.get(i);
        	if(documentParams.get("documentId") != null && !documentParams.get("documentId").toString().isEmpty()){
        		Map<String, Object> resultStatus = new HashMap<String, Object>();
        		Map<String, Object> einvApiParams = new HashMap<String, Object>();
                einvApiParams.put("cleartaxUrl", ClearTaxApiDomain + documentParams.get("documentId").toString() +  ClearTaxApiChkSts+"?einvoice-type=SALES");
                einvApiParams.put("documentId", documentParams.get("documentId").toString());
                einvApiParams.put("invRefNo", documentParams.get("invRefNo").toString());
        		resultStatus = clearTaxCheckStatusReqApi(einvApiParams);
        	}
        }

        return resultValue;
    }

    @Override
    public Map<String, Object> clearTaxCheckStatusReqApi(Map<String, Object> params) {
        Map<String, Object> resultValue = new HashMap<String, Object>();
        resultValue.put("status", AppConstants.FAIL);
        resultValue.put("message", "Cleartax Failed: Please contact Administrator.");

        String respTm = null;
        String lmsApiUserId = "3";
        String key= ClearTaxApiKey;
        String value = ClearTaxApiValue;

        StopWatch stopWatch = new StopWatch();
        stopWatch.reset();
        stopWatch.start();

        String CleartaxUrl = params.get("cleartaxUrl").toString();
        String invRefNo = params.get("invRefNo").toString();
        String output1 = "";
        String ResponseCode = "";
        String ResponseMsg = "";
        int respSeq = 0;
        GovEInvcCheckStatusResponseVO p = new GovEInvcCheckStatusResponseVO();
        try{
            URL url = new URL(CleartaxUrl);

            //insert to api0004m
            //
            LOGGER.error("Start Calling Cleartax API ...." + CleartaxUrl + "......\n");
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setDoOutput(true);
            conn.setRequestMethod("GET");
//            conn.setRequestProperty("Content-Type", "application/json");
            conn.setRequestProperty("x-clear-tin", ClearTaxApiTin);
            conn.setRequestProperty(ClearTaxApiKey, ClearTaxApiValue);
//            OutputStream os = conn.getOutputStream();
//            os.flush();

            int responseCode = conn.getResponseCode();
            //System.out.println("Response Code: " + responseCode);

            LOGGER.error("Start Calling Cleartax API return......\n");
            LOGGER.error("Start Calling Cleartax API return" + conn.getResponseMessage() + "......\n");

            if (conn.getResponseCode() != HttpURLConnection.HTTP_BAD_REQUEST) {
                respSeq = govEInvoiceMapper.selectApiInvoiceSeq();
                BufferedReader br = new BufferedReader(new InputStreamReader(
                        (conn.getInputStream())));
                conn.getResponseMessage();

                String output = "";
                LOGGER.debug("Output from Server .... \n");
                while ((output = br.readLine()) != null) {
                    output1 = output;
                    LOGGER.debug(output);
                }

                Gson g = new Gson();
                p = g.fromJson(output1, GovEInvcCheckStatusResponseVO.class);

                Map<String, Object> einvUpdParams = new HashMap<>();
                if(p.getSuccess() && p.getStatus().equals("VALID")){
                    String documentId = p.getDocumentId()==null?"":p.getDocumentId().toString();
                    String qrCode = p.getQrCode()==null?"":p.getQrCode().toString();
                    String internalId = p.getInternalId()==null?"":p.getInternalId().toString();
                    String dateTimeValidated = p.getDateTimeValidated()==null?"":p.getDateTimeValidated().toString();

                    einvUpdParams.put("documentId", documentId);
                    einvUpdParams.put("qrCode", qrCode);
                    einvUpdParams.put("dateTimeValidated", dateTimeValidated);
                    einvUpdParams.put("userId", 349);
                    einvUpdParams.put("status", 4);
                }else if(p.getSuccess() && p.getStatus().equals("INVALID")){
                    String documentId = p.getDocumentId()==null?"":p.getDocumentId().toString();
                    String qrCode = p.getQrCode()==null?"":p.getQrCode().toString();
                    String internalId = p.getInternalId()==null?"":p.getInternalId().toString();
                    String dateTimeValidated = p.getDateTimeValidated()==null?"":p.getDateTimeValidated().toString();

                    einvUpdParams.put("documentId", documentId);
                    einvUpdParams.put("qrCode", qrCode);
                    einvUpdParams.put("dateTimeValidated", dateTimeValidated);
                    einvUpdParams.put("userId", 349);
                    einvUpdParams.put("status", 8);
                    ResponseMsg = p.getErrorDetails()==null?"":p.getErrorDetails().toString();
                }
                updEInvByDocId(einvUpdParams);

                conn.disconnect();

                br.close();
            }else{
                resultValue.put("status", AppConstants.FAIL);
                resultValue.put("message", "No Response");
//				p.setCode(String.valueOf(AppConstants.RESPONSE_CODE_INVALID));
//				p.setMessage("No Response");
            }
        }catch(Exception e){
            LOGGER.error("Timeout:");
            LOGGER.error("[CleartaxMemberListInsertUpdate] - Caught Exception: " + e);
            resultValue.put("status", AppConstants.RESPONSE_CODE_TIMEOUT);
            if(output1.equals("")){
                output1 = e.toString();
            }
//			p.setCode(String.valueOf(AppConstants.RESPONSE_CODE_TIMEOUT));
//			p.setStatus(String.valueOf(AppConstants.RESPONSE_CODE_TIMEOUT));
//			p.setMessage("Timeout " + e.toString());
        }finally{
            stopWatch.stop();
            respTm = stopWatch.toString();
            this.rtnRespMsg(respSeq, CleartaxUrl, ResponseCode, ResponseMsg,respTm , "", output1 ,"1", invRefNo);
        }

        return resultValue;
    }

    @Transactional(propagation = Propagation.REQUIRES_NEW)
    @Override
    public int updEInvByDocId(Map<String, Object> params) {
        int result = govEInvoiceMapper.updEInvByDocId(params);
        return result;
    }
}
