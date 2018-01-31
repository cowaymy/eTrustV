package com.coway.trust.api.mobile.services;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.coway.trust.AppConstants;
import com.coway.trust.api.mobile.services.as.ASFailJobRequestDto;
import com.coway.trust.api.mobile.services.as.ASFailJobRequestForm;
import com.coway.trust.api.mobile.services.as.ASReAppointmentRequestDto;
import com.coway.trust.api.mobile.services.as.ASReAppointmentRequestForm;
import com.coway.trust.api.mobile.services.as.ASRequestCustDto;
import com.coway.trust.api.mobile.services.as.ASRequestCustForm;
import com.coway.trust.api.mobile.services.as.ASRequestRegistDto;
import com.coway.trust.api.mobile.services.as.ASRequestRegistForm;
import com.coway.trust.api.mobile.services.as.ASRequestResultDto;
import com.coway.trust.api.mobile.services.as.ASRequestResultForm;
import com.coway.trust.api.mobile.services.as.AfterServiceJobDto;
import com.coway.trust.api.mobile.services.as.AfterServiceJobDto_b;
import com.coway.trust.api.mobile.services.as.AfterServiceJobForm;
import com.coway.trust.api.mobile.services.as.AfterServicePartsDto;
import com.coway.trust.api.mobile.services.as.AfterServicePartsForm;
import com.coway.trust.api.mobile.services.as.AfterServiceResultDetailForm;
import com.coway.trust.api.mobile.services.as.AfterServiceResultDto;
import com.coway.trust.api.mobile.services.as.AfterServiceResultForm;
import com.coway.trust.api.mobile.services.cancelSms.CanCelDto;
import com.coway.trust.api.mobile.services.cancelSms.CanCelSmsForm;
import com.coway.trust.api.mobile.services.heartService.HSFailJobRequestDto;
import com.coway.trust.api.mobile.services.heartService.HSFailJobRequestForm;
import com.coway.trust.api.mobile.services.heartService.HSReAppointmtRequestDto;
import com.coway.trust.api.mobile.services.heartService.HSReAppointmtRequestForm;
import com.coway.trust.api.mobile.services.heartService.HeartServiceJobDto;
import com.coway.trust.api.mobile.services.heartService.HeartServiceJobForm;
import com.coway.trust.api.mobile.services.heartService.HeartServicePartsDto;
import com.coway.trust.api.mobile.services.heartService.HeartServicePartsForm;
import com.coway.trust.api.mobile.services.heartService.HeartServiceResultDetailForm;
import com.coway.trust.api.mobile.services.heartService.HeartServiceResultDto;
import com.coway.trust.api.mobile.services.heartService.HeartServiceResultForm;
import com.coway.trust.api.mobile.services.history.ServiceHistoryDto;
import com.coway.trust.api.mobile.services.history.ServiceHistoryFilterDetailDto;
import com.coway.trust.api.mobile.services.history.ServiceHistoryForm;
import com.coway.trust.api.mobile.services.history.ServiceHistoryPartDetailDto;
import com.coway.trust.api.mobile.services.installation.InstallFailJobRequestDto;
import com.coway.trust.api.mobile.services.installation.InstallFailJobRequestForm;
import com.coway.trust.api.mobile.services.installation.InstallReAppointmentRequestDto;
import com.coway.trust.api.mobile.services.installation.InstallReAppointmentRequestForm;
import com.coway.trust.api.mobile.services.installation.InstallationJobDto;
import com.coway.trust.api.mobile.services.installation.InstallationJobForm;
import com.coway.trust.api.mobile.services.installation.InstallationResultDto;
import com.coway.trust.api.mobile.services.installation.InstallationResultForm;
import com.coway.trust.api.mobile.services.productRetrun.PRFailJobRequestDto;
import com.coway.trust.api.mobile.services.productRetrun.PRFailJobRequestForm;
import com.coway.trust.api.mobile.services.productRetrun.PRReAppointmentRequestDto;
import com.coway.trust.api.mobile.services.productRetrun.PRReAppointmentRequestForm;
import com.coway.trust.api.mobile.services.productRetrun.ProductRetrunJobDto;
import com.coway.trust.api.mobile.services.productRetrun.ProductRetrunJobForm;
import com.coway.trust.api.mobile.services.productRetrun.ProductReturnResultDto;
import com.coway.trust.api.mobile.services.productRetrun.ProductReturnResultForm;
import com.coway.trust.api.mobile.services.sales.OutStandignResultDetail;
import com.coway.trust.api.mobile.services.sales.OutStandingResultVo;
import com.coway.trust.api.mobile.services.sales.RentalServiceCustomerDto;
import com.coway.trust.api.mobile.services.sales.RentalServiceCustomerForm;
import com.coway.trust.biz.common.AdaptorService;
import com.coway.trust.biz.logistics.returnusedparts.ReturnUsedPartsService;
import com.coway.trust.biz.services.as.ASManagementListService;
import com.coway.trust.biz.services.as.ServicesLogisticsPFCService;
import com.coway.trust.biz.services.bs.HsManualService;
import com.coway.trust.biz.services.installation.InstallationResultListService;
import com.coway.trust.biz.services.mlog.MSvcLogApiService;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.cmmn.model.SmsResult;
import com.coway.trust.cmmn.model.SmsVO;
import com.coway.trust.util.CommonUtils;
import com.ibm.icu.text.DateFormat;
import com.ibm.icu.text.SimpleDateFormat;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;


@Api(value = "service api", description = "service api")
@RestController(value = "serviceApiController")
@RequestMapping(AppConstants.MOBILE_API_BASE_URI + "/service")
public class ServiceApiController {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(ServiceApiController.class);
	
	@Resource(name = "MSvcLogApiService")
	private MSvcLogApiService MSvcLogApiService;

	@Resource(name = "ASManagementListService")
	private ASManagementListService ASManagementListService;

	@Resource(name = "installationResultListService")
	private InstallationResultListService installationResultListService;
	
	
	@Resource(name = "hsManualService")
	private HsManualService hsManualService;
	
	@Autowired
	private MessageSourceAccessor messageAccessor;
	@Resource(name = "servicesLogisticsPFCService")
	private ServicesLogisticsPFCService servicesLogisticsPFCService;
	
	@Autowired
	private AdaptorService adaptorService;	
	
	@Resource(name = "returnUsedPartsService")
	private ReturnUsedPartsService returnUsedPartsService;
	
	
	
	
	@ApiOperation(value = "Heart Service Job List Search", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	@RequestMapping(value = "/heartServiceJobList", method = RequestMethod.GET)
	public ResponseEntity<List<HeartServiceJobDto>> getHeartServiceJob(
			@ModelAttribute HeartServiceJobForm HeartServiceJobForm) throws Exception {

		Map<String, Object> params = HeartServiceJobForm.createMap(HeartServiceJobForm);

		List<EgovMap> HeartServiceJobList = MSvcLogApiService.getHeartServiceJobList(params);

		for (int i = 0; i < HeartServiceJobList.size(); i++) {
			LOGGER.debug("HeartServiceJobList    값 : {}", HeartServiceJobList.get(i));

		}
		
		List<HeartServiceJobDto> list = HeartServiceJobList.stream().map(r -> HeartServiceJobDto.create(r))
				.collect(Collectors.toList());

		return ResponseEntity.ok(list);
	}
	
	
	
	
	
	@ApiOperation(value = "Heart Service Job List batch Search", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	@RequestMapping(value = "/heartServiceJobList_b", method = RequestMethod.GET)
	public ResponseEntity<List<HeartServiceJobDto>> getHeartServiceJob_b(
			@ModelAttribute HeartServiceJobForm HeartServiceJobForm) throws Exception {

		Map<String, Object> params = HeartServiceJobForm.createMap(HeartServiceJobForm);

		List<EgovMap> HeartServiceJobList = MSvcLogApiService.getHeartServiceJobList_b(params);

		for (int i = 0; i < HeartServiceJobList.size(); i++) {
			LOGGER.debug("HeartServiceJobList    값 : {}", HeartServiceJobList.get(i));

		}
		
		List<HeartServiceJobDto> list = HeartServiceJobList.stream().map(r -> HeartServiceJobDto.create(r))
				.collect(Collectors.toList());

		return ResponseEntity.ok(list);
	}	
	
	
	
	
	@ApiOperation(value = "AfterServiceJob List Search", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	@RequestMapping(value = "/afterServiceJobList", method = RequestMethod.GET)
	public ResponseEntity<List<AfterServiceJobDto>> getHeartServiceJob(
			@ModelAttribute AfterServiceJobForm AfterServiceJobForm) throws Exception {

		Map<String, Object> params = AfterServiceJobForm.createMap(AfterServiceJobForm);

		List<EgovMap> AfterServiceJobList = MSvcLogApiService.getAfterServiceJobList(params);

		for (int i = 0; i < AfterServiceJobList.size(); i++) {
			LOGGER.debug("AfterServiceJobList    값 : {}", AfterServiceJobList.get(i));

		}
		
		List<AfterServiceJobDto> list = AfterServiceJobList.stream().map(r -> AfterServiceJobDto.create(r))
				.collect(Collectors.toList());

		return ResponseEntity.ok(list);
	}
	

	
	
	
	@ApiOperation(value = "AfterServiceJob List batch Search", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	@RequestMapping(value = "/afterServiceJobList_b", method = RequestMethod.GET)
	public ResponseEntity<List<AfterServiceJobDto_b>> getHeartServiceJob_b(
			@ModelAttribute AfterServiceJobForm AfterServiceJobForm) throws Exception {

		Map<String, Object> params = AfterServiceJobForm.createMap(AfterServiceJobForm);

		List<EgovMap> AfterServiceJobList = MSvcLogApiService.getAfterServiceJobList_b(params);

		for (int i = 0; i < AfterServiceJobList.size(); i++) {
			LOGGER.debug("AfterServiceJobList    값 : {}", AfterServiceJobList.get(i));

		}
		
		List<AfterServiceJobDto_b> list = AfterServiceJobList.stream().map(r -> AfterServiceJobDto_b.create(r))
				.collect(Collectors.toList());

		return ResponseEntity.ok(list);
	}
	
	
	
	
	
	
	@ApiOperation(value = "InstallationJob List Search", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	@RequestMapping(value = "/installationJobList", method = RequestMethod.GET)
	public ResponseEntity<List<InstallationJobDto>> getInstallationJobList(
			@ModelAttribute InstallationJobForm InstallationJobForm) throws Exception {

		Map<String, Object> params = InstallationJobForm.createMap(InstallationJobForm);

		List<EgovMap> InstallationJobList = MSvcLogApiService.getInstallationJobList(params);

		for (int i = 0; i < InstallationJobList.size(); i++) {
			LOGGER.debug("InstallationJobList    값 : {}", InstallationJobList.get(i));

		}
		
		List<InstallationJobDto> list = InstallationJobList.stream().map(r -> InstallationJobDto.create(r))
				.collect(Collectors.toList());

		return ResponseEntity.ok(list);
	}
	
	
	
	
	@ApiOperation(value = "InstallationJob List batchSearch", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	@RequestMapping(value = "/installationJobList_b", method = RequestMethod.GET)
	public ResponseEntity<List<InstallationJobDto>> getInstallationJobList_b(
			@ModelAttribute InstallationJobForm InstallationJobForm) throws Exception {

		Map<String, Object> params = InstallationJobForm.createMap(InstallationJobForm);

		List<EgovMap> InstallationJobList = MSvcLogApiService.getInstallationJobList_b(params);

		for (int i = 0; i < InstallationJobList.size(); i++) {
			LOGGER.debug("InstallationJobList    값 : {}", InstallationJobList.get(i));

		}
		
		List<InstallationJobDto> list = InstallationJobList.stream().map(r -> InstallationJobDto.create(r))
				.collect(Collectors.toList());

		return ResponseEntity.ok(list);
	}
	
	
	
	
	
	@ApiOperation(value = "ProductRetrunJob List Search", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	@RequestMapping(value = "/productRetrunJobList", method = RequestMethod.GET)
	public ResponseEntity<List<ProductRetrunJobDto>> getProductRetrunJobList(
			@ModelAttribute ProductRetrunJobForm ProductRetrunJobForm) throws Exception {

		Map<String, Object> params = ProductRetrunJobForm.createMap(ProductRetrunJobForm);

		List<EgovMap> ProductRetrunJobList = MSvcLogApiService.getProductRetrunJobList(params);

		for (int i = 0; i < ProductRetrunJobList.size(); i++) {
			LOGGER.debug("ProductRetrunJobList    값 : {}", ProductRetrunJobList.get(i));

		}
		
		List<ProductRetrunJobDto> list = ProductRetrunJobList.stream().map(r -> ProductRetrunJobDto.create(r))
				.collect(Collectors.toList());

		return ResponseEntity.ok(list);
	}
	
	
	
	
	@ApiOperation(value = "ProductRetrunJob List batch Search", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	@RequestMapping(value = "/productRetrunJobList_b", method = RequestMethod.GET)
	public ResponseEntity<List<ProductRetrunJobDto>> getProductRetrunJobList_b(
			@ModelAttribute ProductRetrunJobForm ProductRetrunJobForm) throws Exception {

		Map<String, Object> params = ProductRetrunJobForm.createMap(ProductRetrunJobForm);

		List<EgovMap> ProductRetrunJobList = MSvcLogApiService.getProductRetrunJobList_b(params);

		for (int i = 0; i < ProductRetrunJobList.size(); i++) {
			LOGGER.debug("ProductRetrunJobList    값 : {}", ProductRetrunJobList.get(i));

		}
		
		List<ProductRetrunJobDto> list = ProductRetrunJobList.stream().map(r -> ProductRetrunJobDto.create(r))
				.collect(Collectors.toList());

		return ResponseEntity.ok(list);
	}
	
	
	
	
	
	@ApiOperation(value = "Heart Service Parts List Search", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	@RequestMapping(value = "/heartServiceParts", method = RequestMethod.GET)
	public ResponseEntity<List<HeartServicePartsDto>> heartServiceParts(
			@ModelAttribute HeartServicePartsForm heartServicePartsForm) throws Exception {

		Map<String, Object> params = HeartServicePartsForm.createMap(heartServicePartsForm); 

		List<EgovMap> HeartServiceParts = MSvcLogApiService.heartServiceParts(params);

		for (int i = 0; i < HeartServiceParts.size(); i++) {
			LOGGER.debug("HeartServiceParts    값 : {}", HeartServiceParts.get(i));

		}
		
		List<HeartServicePartsDto> list = HeartServiceParts.stream().map(r -> HeartServicePartsDto.create(r))
				.collect(Collectors.toList());

		return ResponseEntity.ok(list);
	}
	
	
	
	
	
	@ApiOperation(value = "Heart Service Parts List batch Search", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	@RequestMapping(value = "/heartServiceParts_b", method = RequestMethod.GET)
	public ResponseEntity<List<HeartServicePartsDto>> heartServiceParts_b(
			@ModelAttribute HeartServicePartsForm heartServicePartsForm) throws Exception {

		Map<String, Object> params = HeartServicePartsForm.createMap(heartServicePartsForm); 

		List<EgovMap> HeartServiceParts = MSvcLogApiService.heartServiceParts_b(params);

		for (int i = 0; i < HeartServiceParts.size(); i++) {
			LOGGER.debug("HeartServiceParts    값 : {}", HeartServiceParts.get(i));

		}
		
		List<HeartServicePartsDto> list = HeartServiceParts.stream().map(r -> HeartServicePartsDto.create(r))
				.collect(Collectors.toList());

		return ResponseEntity.ok(list);
	}
	
	
	
	
	@ApiOperation(value = "After Service Parts List Search", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	@RequestMapping(value = "/afterServiceParts", method = RequestMethod.GET)
	public ResponseEntity<List<AfterServicePartsDto>> afterServiceParts(
			@ModelAttribute AfterServicePartsForm afterServicePartsForm) throws Exception {

		Map<String, Object> params = AfterServicePartsForm.createMap(afterServicePartsForm);

		List<EgovMap> AfterServiceParts = MSvcLogApiService.afterServiceParts(params);

		for (int i = 0; i < AfterServiceParts.size(); i++) {
			LOGGER.debug("AfterServiceParts    값 : {}", AfterServiceParts.get(i));

		}
		
		List<AfterServicePartsDto> list = AfterServiceParts.stream().map(r -> AfterServicePartsDto.create(r))
				.collect(Collectors.toList());

		return ResponseEntity.ok(list);
	}
	
	
	
	
	@ApiOperation(value = "After Service Parts List batch Search", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	@RequestMapping(value = "/afterServiceParts_b", method = RequestMethod.GET)
	public ResponseEntity<List<AfterServicePartsDto>> afterServiceParts_b(
			@ModelAttribute AfterServicePartsForm afterServicePartsForm) throws Exception {

		Map<String, Object> params = AfterServicePartsForm.createMap(afterServicePartsForm);

		List<EgovMap> AfterServiceParts = MSvcLogApiService.afterServiceParts_b(params);

		for (int i = 0; i < AfterServiceParts.size(); i++) {
			LOGGER.debug("AfterServiceParts    값 : {}", AfterServiceParts.get(i));

		}
		
		List<AfterServicePartsDto> list = AfterServiceParts.stream().map(r -> AfterServicePartsDto.create(r))
				.collect(Collectors.toList());

		return ResponseEntity.ok(list);
	}
	
	
	
	@ApiOperation(value = "Heart", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	@RequestMapping(value = "/heartServiceResult", method = RequestMethod.POST)
	public ResponseEntity<HeartServiceResultDto> hsRegistration (@RequestBody List<HeartServiceResultForm> heartForms) throws Exception {

		String transactionId = "";
		List<Map<String, Object>> heartLogs = null;
		List<Map<String, Object>> hsTransLogs1 = null;
		SessionVO sessionVO = new SessionVO();
		
		Calendar cal = Calendar.getInstance();
		 
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
        String strToday = sdf.format(cal.getTime());
        
		//현재 년도, 월, 일
	    StringBuffer today2 = new StringBuffer();
        today2.append(String.format("%02d", cal.get(cal.DATE)));
	    today2.append(String.format("%02d", cal.get(cal.MONTH) + 1));
	    today2.append(String.format("%04d", cal.get(cal.YEAR)));
	    
	    String toSetlDt = today2.toString(); 
	    
	    
		int year = cal.get ( cal.YEAR );
		int month = cal.get ( cal.MONTH ) + 1 ;
		int date = cal.get ( cal.DATE ) ;
		
		String todate2 = (String.valueOf(date) +String.valueOf(month) + String.valueOf(year));
		
		// mobile 에서 받은 데이터를 로그 테이블에 insert......
		LOGGER.debug("### INSERT_HEART_LOG : {}", RegistrationConstants.IS_INSERT_HEART_LOG);
		LOGGER.debug("### TransactionId : {}", RegistrationConstants.IS_INSERT_HEART_LOG);
		if (RegistrationConstants.IS_INSERT_HEART_LOG) {

			heartLogs = new ArrayList<>();
			for (HeartServiceResultForm heart : heartForms) {
				heartLogs.addAll(heart.createMaps(heart));
			}

			// List<Map<String, Object>> heartLogs = heartForms.stream().flatMap(r -> r.createMaps(r))
			// .collect(Collectors.toList());
			MSvcLogApiService.saveHearLogs(heartLogs);

			transactionId = heartForms.get(0).getTransactionId();
		}

		hsTransLogs1 = new ArrayList<>();
		for(HeartServiceResultForm hsService1 : heartForms) {
			hsTransLogs1.addAll(hsService1.createMaps1(hsService1)); 
		}
		
		if(hsTransLogs1.size()> 0) {  
			for(int i=0 ; i < hsTransLogs1.size() ; i++ ){
				  
				LOGGER.debug("hsTransLogs11111 값 : {}", hsTransLogs1.get(i));
				
				Map<String, Object>   hfterServiceDetail = null;
				List<Map<String, Object>> paramsDetail = HeartServiceResultDetailForm.createMaps((List<HeartServiceResultDetailForm>) hsTransLogs1.get(i).get("heartDtails"));
				List<Object> paramsDetailList =                   HeartServiceResultDetailForm.createMaps1((List<HeartServiceResultDetailForm>) hsTransLogs1.get(i).get("heartDtails"));
				
				List<Object> paramsDetailObj = (List<Object>) hsTransLogs1.get(i).get("heartDtails");

				Map<String, Object> params = hsTransLogs1.get(i);  
				params.put("updList", paramsDetail);
				
				
				//result 체크 
				 int  isHsCnt =	hsManualService.isHsAlreadyResult(params);
				 
				 
				 //결과가 없을 경우 
				 if(isHsCnt ==  0){
					 
        				String userId = MSvcLogApiService.getUseridToMemid(params);
        				sessionVO.setUserId(Integer.parseInt(userId));
        				
        				
        				Map<String, Object> getHsBasic = MSvcLogApiService.getHsBasic(params);
        				//api setting
        				params.put("hidschdulId", getHsBasic.get("schdulId"));
        				params.put("hidSalesOrdId", String.valueOf(getHsBasic.get("salesOrdId")));
        				params.put("hidCodyId", (String)userId);
        //				params.put("settleDate", todate2);
        				params.put("settleDate", toSetlDt);
        				params.put("resultIsSync", '0');
        				params.put("resultIsEdit", '0');
        				params.put("resultStockUse", '1');
        				params.put("resultIsCurr", '1');
        				params.put("resultMtchId", '0');
        				params.put("resultIsAdj", '0');
        				params.put("cmbStatusType","4");
        				params.put("renColctId", "0");
        
        				//			api 넘어온거				
        				params.put("remark",hsTransLogs1.get(i).get("resultRemark"));
        				params.put("cmbCollectType",String.valueOf(hsTransLogs1.get(i).get("rcCode")));
        				
        //				api 추가된거	
        				params.put("temperateSetng",String.valueOf(hsTransLogs1.get(i).get("temperatureSetting")));
        				params.put("nextAppntDt",hsTransLogs1.get(i).get("nextAppointmentDate"));
        				params.put("nextAppointmentTime",String.valueOf(hsTransLogs1.get(i).get("nextAppointmentTime")));
        				params.put("ownerCode",String.valueOf(hsTransLogs1.get(i).get("ownerCode")));
        				params.put("resultCustName",hsTransLogs1.get(i).get("resultCustName"));
        				params.put("resultMobileNo",String.valueOf(hsTransLogs1.get(i).get("resultIcMobileNo")));
        				params.put("resultRptEmailNo",String.valueOf(hsTransLogs1.get(i).get("resultReportEmailNo")));
        				params.put("resultAceptName",hsTransLogs1.get(i).get("resultAcceptanceName"));
        				params.put("sgnDt",hsTransLogs1.get(i).get("signData"));
        //				params.put("remark",hsTransLogs1.get(i).get("signRegDate"));
        //				params.put("remark",hsTransLogs1.get(i).get("signRegTime"));
        //				params.put("remark",hsTransLogs1.get(i).get("transactionId"));
        				
        				
        				
        				LOGGER.debug("params22222 값 : {}", params);
        
        				
        // service to value setting				
        				Map<String, Object>   asResultInsert = new HashMap();
        				LOGGER.debug("hsResultInsert1111111111 값 : {}", asResultInsert);
        				
        				Map  rtnValue  = hsManualService.addIHsResult(params,paramsDetailList,sessionVO);
        				
        				
        
        				if( null !=rtnValue){
        					HashMap   spMap =(HashMap)rtnValue.get("spMap");
        					LOGGER.debug("spMap :"+ spMap.toString());   
        					if(! "000".equals(spMap.get("P_RESULT_MSG"))){
        						rtnValue.put("logerr","Y");
        						
        					}
        					
        					servicesLogisticsPFCService.SP_SVC_LOGISTIC_REQUEST(spMap);
        				}
        				
				}else{
					if (RegistrationConstants.IS_INSERT_HEART_LOG) {
						MSvcLogApiService.updateSuccessStatus(transactionId);
					}
				}
				 
//					//>>>>>>>>>>>>>>>>>logs call
//					LOGGER.info(" serviceNo>>>>>> : {}", hsTransLogs1.get(i).get("serviceNo").toString());
//					returnUsedPartsService.returnPartsInsert(hsTransLogs1.get(i).get("serviceNo").toString());
			}

			
		}
		
		

		
		
		
//***************///
		
		


		return ResponseEntity.ok(HeartServiceResultDto.create(transactionId));
	}
	
	
	
	
	
	@ApiOperation(value = "AfterService Result Registration", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	@RequestMapping(value = "/afterServiceResult", method = RequestMethod.POST)
	public ResponseEntity<AfterServiceResultDto> asRegistration (@RequestBody List<AfterServiceResultForm> afterServiceForms) throws Exception {

		String transactionId = "";
		List<Map<String, Object>> asTransLogs = null;
		List<Map<String, Object>> asTransLogs1 = null;
		
//		Date d = new Date ();
		Calendar cal = Calendar.getInstance();
     	 
	    StringBuffer today2 = new StringBuffer();
        today2.append(String.format("%02d", cal.get(cal.DATE)));
	    today2.append(String.format("%02d", cal.get(cal.MONTH) + 1));
	    today2.append(String.format("%04d", cal.get(cal.YEAR)));

	    String toSetlDt = today2.toString();
        
		Date todate = new Date();
		Calendar today1 = Calendar.getInstance();
		
		SimpleDateFormat transFormat = new SimpleDateFormat("dd-mm-yyyy");
		SimpleDateFormat transFormatYY = new SimpleDateFormat("yyyymmdd");
		SimpleDateFormat transFormat1 = new SimpleDateFormat("ddmmyyyy");
		SimpleDateFormat transFormatHH = new SimpleDateFormat("HHmmss");

		DateFormat sdFormat = new SimpleDateFormat("ddMMyyyy");
		DateFormat sdFormat1 = new SimpleDateFormat("dd-MM-yyyy");
		DateFormat sdFormat2 = new SimpleDateFormat("yyyymmdd");
		
		
		String ddMMCurDate =  transFormat.format(new Date());
		String curDate = transFormatYY.format(new Date());
		String curTime = transFormatHH.format(new Date());
		
		//현재 년도, 월, 일
		int year = cal.get ( cal.YEAR );
		int month = cal.get ( cal.MONTH ) + 1 ;
		int date = cal.get ( cal.DATE ) ;
		
//		String todate2 = (String.valueOf(date) +String.valueOf(month) + String.valueOf(year));
		
		
		// mobile 에서 받은 데이터를 로그 테이블에 insert......
		LOGGER.debug("### IS_INSERT_AS_LOG : {}", RegistrationConstants.IS_INSERT_AS_LOG);
		LOGGER.debug("### TransactionId : {}", RegistrationConstants.IS_INSERT_AS_LOG);

		if (RegistrationConstants.IS_INSERT_AS_LOG) {

			asTransLogs = new ArrayList<>();
			for (AfterServiceResultForm afterService : afterServiceForms) {
				asTransLogs.addAll(afterService.createMaps(afterService));
			}

			MSvcLogApiService.saveAfterServiceLogs(asTransLogs);

			transactionId = afterServiceForms.get(0).getTransactionId();
		}
		

		// business service....
		// TODO : heartService.xxxx 구현 필요.....		
//		MSvcLogApiService.aSresultRegistration(asTransLogs);

//		for (AfterServiceResultForm afterService1 : afterServiceForms) {
//			asTransLogs1.addAll(afterService1.createMaps1(afterService1));
//		}
		
		

		
		asTransLogs1 = new ArrayList<>();
		for(AfterServiceResultForm afterService1 : afterServiceForms) {
			asTransLogs1.addAll(afterService1.createMaps1(afterService1)); 
		}
		
		if(asTransLogs1.size()> 0) {  
			for(int i=0 ; i < asTransLogs1.size() ; i++ ){
				  
				LOGGER.debug("asTransLogs11111 값 : {}", asTransLogs1.get(i));
				
				
				Map<String, Object> alreadyP = asTransLogs1.get(i);  

				//result 체크 
				 int  isAsCnt =	ASManagementListService.isAsAlreadyResult(alreadyP);
				 
				 
				 //결과가 없을 경우 
				 if(isAsCnt == 0){
					 
					 				Map<String, Object>   afterServiceDetail = null;
                     				
                     				List<Map<String, Object>> paramsDetail = AfterServiceResultDetailForm.createMaps((List<AfterServiceResultDetailForm>) asTransLogs1.get(i).get("partList"));
                     
                     				
                     				LOGGER.debug("asTransLogs11111 {}" +paramsDetail);
                     				 
                     				List<Map<String, Object>>    paramsDetailCvt =  new ArrayList<Map<String, Object>>() ;
                     				
                     				long  totPrc = 0;
                     				
                     				for(int x=0 ; x < paramsDetail.size(); x++){
                     					  
                     					Map<String, Object> map = new HashMap<String, Object>();
                     					
                     					map.put("filterDesc", "API"); 
                     					if(paramsDetail.get(x).get("filterCode")== null || "".equals(paramsDetail.get(x).get("filterCode"))){
                     						map.put("filterID", paramsDetail.get(x).get("filterCode") );
                     					}else{
                     						map.put("filterID", paramsDetail.get(x).get("filterCode") );
                     					}
                     					
                     					
                     					if(paramsDetail.get(x).get("exchangeId")==null){
                     						map.put("filterExCode", 0);
                     					}else{
                     						map.put("filterExCode", paramsDetail.get(x).get("exchangeId"));
                     					}
                     					
                     					if(paramsDetail.get(x).get("filterChangeQty")==null){
                     						map.put("filterQty", 0);
                     					}else{
                     						map.put("filterQty", String.valueOf(paramsDetail.get(x).get("filterChangeQty")));
                     					}
                     					
                     					if(paramsDetail.get(x).get("salesPrice")==null){
                     						map.put("filterPrice", 0);
                     					}else{
                     						map.put("filterPrice", paramsDetail.get(x).get("salesPrice"));
                     					}
                     					
                     					
                     					int foc =  CommonUtils.intNvl(paramsDetail.get(x).get("chargesFoc"));
                     					
                     					if(foc ==1){
                     						map.put("filterType", "FOC");
                     					}else{
                     						map.put("filterType", String.valueOf(paramsDetail.get(x).get("chargesFoc")));
                     					}
                     					
                     					
                     					
                     					if(paramsDetail.get(x).get("filterBarcdSerialNo")==null){
                     						map.put("srvFilterLastSerial", "");
                     					}else{
                     						map.put("srvFilterLastSerial", paramsDetail.get(x).get("filterBarcdSerialNo"));
                     					}
                     					
                     					
                     					int qty                 = Integer.parseInt(String.valueOf(paramsDetail.get(x).get("filterChangeQty")));
                     					long  filterPrice    = Long.parseLong(String.valueOf(paramsDetail.get(x).get("salesPrice")));
                     					
                     					long amt  =0;
                     					
                     					if(foc==0){
                         					amt = qty * filterPrice;
                         					totPrc = totPrc +amt ;
                         				}
                     					
                     					map.put("filterRemark", "");
                     					map.put("filterTotal",amt);
                     					
                     					paramsDetailCvt.add(map);
                     					 
                     				} 
                     				
                     				
                     				/*
                     				Map<String , Object> paramsFilter = paramsDetail.get(i);
                     				paramsDetail.get(i).put("filterType", String.valueOf(paramsDetail.get(i).get("partsType")));
                     				paramsDetail.get(i).put("filterDesc", "API"); 
                     				
                     				if(paramsDetail.get(i).get("filterCode")== null || "".equals(paramsDetail.get(i).get("filterCode"))){
                     					paramsDetail.get(i).put("filterExCode", 0);
                     				}else{
                     					paramsDetail.get(i).put("filterExCode", paramsDetail.get(i).get("filterCode"));
                     				}
                     				
                     				if(paramsDetail.get(i).get("filterChangeQty")==null){
                     					paramsDetail.get(i).put("filterQty", 0);
                     				}else{
                     					paramsDetail.get(i).put("filterQty", String.valueOf(paramsDetail.get(i).get("filterChangeQty")));
                     				}
                     				
                     				if(paramsDetail.get(i).get("salesPrice")==null){
                     					paramsDetail.get(i).put("filterPrice", 0);
                     				}else{
                     					paramsDetail.get(i).put("filterPrice", paramsDetail.get(i).get("salesPrice"));
                     				}
                     				
                     				paramsDetail.get(i).put("filterRemark", "");
                     				paramsDetail.get(i).put("filterID", paramsDetail.get(i).get("filterCode") );
                     				paramsDetail.get(i).put("filterTotal", "1");
                     				*/
                     				
                     				Map<String, Object> params = asTransLogs1.get(i);  
                     //				Map<String, Object> servasMasterMap = asTransLogs.get(i);
                     				
                     				
                     				Map<String, Object> getAsBasic = MSvcLogApiService.getAsBasic(params);
                     				
                     				if(getAsBasic.get("asSoId")!=null){
                     					params.put("AS_SO_ID", String.valueOf(getAsBasic.get("asSoId")));
                     				}else{
                     					params.put("AS_SO_ID", "");
                     				}
                     				
                     				if(getAsBasic.get("userId") !=null){		
                     					params.put("AS_CT_ID", String.valueOf(getAsBasic.get("userId")));
                     				}else{
                     					params.put("AS_CT_ID", "");
                     				}
                     				
                     				params.put("AS_RESULT_STUS_ID", '4');
                     
                     				
                     				
                     				
                     //				params.put("AS_FAIL_RESN_ID", getAsBasic.get("as_failResnId"));
                     				params.put("AS_REN_COLCT_ID", 0);
                     				
                     				if(getAsBasic.get("asCmms")!=null){		
                     					params.put("AS_CMMS", String.valueOf(getAsBasic.get("asCmms")));
                     				}else{
                     					params.put("AS_CMMS", "");
                     				}
                     				
                     				if(getAsBasic.get("asBrnchId")!=null){		
                     					params.put("AS_BRNCH_ID", String.valueOf(getAsBasic.get("asBrnchId")));
                     				}else{
                     					params.put("AS_BRNCH_ID", "");
                     				}
                     				
                     				if(getAsBasic.get("asWhId")!=null){						
                     					params.put("AS_WH_ID", String.valueOf(getAsBasic.get("asWhId")));
                     				}else{
                     					params.put("AS_WH_ID", "");
                     				}
                     				
                     				
                     //				params.put("AS_RESULT_REM", getAsBasic.get("resultRemark"));
                     				
                     				if(getAsBasic.get("asMalfuncId")!=null){						
                     					params.put("AS_MALFUNC_ID", String.valueOf(getAsBasic.get("asMalfuncId")));
                     				}else{
                     					params.put("AS_MALFUNC_ID", "");
                     				}
                     				
                     				if(getAsBasic.get("asMalfuncResnId")!=null){					
                     					params.put("AS_MALFUNC_RESN_ID", String.valueOf(getAsBasic.get("asMalfuncResnId")));
                     				}else{
                     					params.put("AS_MALFUNC_RESN_ID", "");
                     				}
                     				
                     				params.put("AS_DEFECT_GRP_ID", 0);
                     				params.put("AS_DEFECT_PART_GRP_ID", 0);
                     //				params.put("AS_WORKMNSH", getAsBasic.get("asWorkmnsh"));
                     
                     				
                     				params.put("AS_ACSRS_AMT", 0);
                     			
                     				
                     				params.put("AS_FILTER_AMT",totPrc);
                     				
                     				
                     				long totamt =0;
                     			    try{
                         				totamt  =Long.parseLong(String.valueOf(asTransLogs1.get(i).get("labourCharge")));
                     			    }catch(Exception e){
                     			    	totamt =0;
                     			    }		
                     						
                     				params.put("AS_TOT_AMT", totPrc +totamt);   
                     				
                     				params.put("AS_RESULT_IS_SYNCH", 0);
                     				params.put("AS_RCALL", 0);
                     				
                     				if(getAsBasic.get("asResultStockUse")!=null){							
                     					params.put("AS_RESULT_STOCK_USE", String.valueOf(getAsBasic.get("asResultStockUse")));
                     				}else{
                     					params.put("AS_RESULT_STOCK_USE", "");
                     				}
                     				
                     				params.put("AS_RESULT_TYPE_ID", 457);
                     				params.put("AS_RESULT_IS_CURR", 1);
                     				params.put("AS_RESULT_MTCH_ID", 0);
                     				params.put("AS_RESULT_NO_ERR", "");
                     				params.put("AS_ENTRY_POINT", 0);
                     				params.put("AS_WORKMNSH_TAX_CODE_ID", 0);
                     				params.put("AS_WORKMNSH_TXS", 0);
                     				params.put("AS_RESULT_MOBILE_ID", 0);
                     				
                     				
                     				
                     				if(!"".equals(getAsBasic.get("asResultNo"))){
                     					params.put("AS_RESULT_NO", String.valueOf(getAsBasic.get("asResultNo")));
                     				}else{
                     					params.put("AS_RESULT_NO", "");
                     				}
                     				
                     				if(getAsBasic.get("asResultId")!=null){						
                     					params.put("AS_RESULT_ID", String.valueOf(getAsBasic.get("asResultId")));
                     				}else{
                     					params.put("AS_RESULT_ID", "");
                     				}
                     				
                     				if(getAsBasic.get("asno")!=null){								
                     					params.put("AS_NO", String.valueOf(getAsBasic.get("asno")));
                     				}else{
                     					params.put("AS_NO", "");
                     				}
                     				
                     				params.put("HC_REM", " ");
                     				
                     				//004
                     				
                     				if(getAsBasic.get("asId")!=null){								
                     					params.put("AS_ENTRY_ID", String.valueOf(getAsBasic.get("asId")));
                     				}else{
                     					params.put("AS_ENTRY_ID", "");
                     				}
                     				
                     				if(asTransLogs1.get(i).get("serviceNo")!=null){								
                     					params.put("AS_NO", String.valueOf(asTransLogs1.get(i).get("serviceNo")));
                     				}else{
                     					params.put("AS_NO", "");
                     				}
                     				
                     				
                     				if(asTransLogs1.get(i).get("defectTypeId")!=null){								
                     					params.put("AS_DEFECT_TYPE_ID", String.valueOf(asTransLogs1.get(i).get("defectTypeId")));
                     				}else{
                     					params.put("AS_DEFECT_TYPE_ID", "");
                     				}
                     				
                     				if(asTransLogs1.get(i).get("defectId")!=null){						
                     					params.put("AS_DEFECT_ID", String.valueOf(asTransLogs1.get(i).get("defectId")));
                     				}else{
                     					params.put("AS_DEFECT_ID", "");
                     				}
                     				
                     				if(asTransLogs1.get(i).get("defectPartId")!=null){						
                     					params.put("AS_DEFECT_PART_ID", String.valueOf(asTransLogs1.get(i).get("defectPartId")));
                     				}else{
                     					params.put("AS_DEFECT_PART_ID", "");
                     				}
                     				
                     				
                     				if(asTransLogs1.get(i).get("defectDetailReasonId")!=null){						
                     					params.put("AS_DEFECT_DTL_RESN_ID", String.valueOf(asTransLogs1.get(i).get("defectDetailReasonId")));
                     				}else{
                     					params.put("AS_DEFECT_DTL_RESN_ID", "");
                     				}
                     				
                     				if(asTransLogs1.get(i).get("solutionReasonId")!=null){						
                     					params.put("AS_SLUTN_RESN_ID", String.valueOf(asTransLogs1.get(i).get("solutionReasonId")));
                     				}else{
                     					params.put("AS_SLUTN_RESN_ID", "");
                     				}
                     				
                     //				params.put("AS_SETL_DT", todate2);
                     				params.put("AS_SETL_DT", toSetlDt);
                     				params.put("AS_SETL_TM", curTime);
                     				
                     				
                     				if(asTransLogs1.get(i).get("labourCharge")!=null){									
                     					params.put("AS_WORKMNSH", String.valueOf(asTransLogs1.get(i).get("labourCharge")));
                     				}else{
                     					params.put("AS_WORKMNSH", "");
                     				}
                     				
                     				params.put("AS_RESULT_REM", asTransLogs1.get(i).get("resultRemark"));
                     				
                     				//
                     				if(asTransLogs1.get(i).get("inHouseRepairRemark")!=null){									
                     					params.put("IN_HUSE_REPAIR_REM", String.valueOf(asTransLogs1.get(i).get("inHouseRepairRemark")));
                     				}else{
                     					params.put("IN_HUSE_REPAIR_REM", "");
                     				}
                     				
                     				if(asTransLogs1.get(i).get("inHouseRepairReplacementYN")!=null){									
                     					params.put("IN_HUSE_REPAIR_REPLACE_YN", String.valueOf(asTransLogs1.get(i).get("inHouseRepairReplacementYN")));
                     				}else{
                     					params.put("IN_HUSE_REPAIR_REPLACE_YN", "");
                     				}
                     				
                     				Date inHouseRepairPromisedDate ;
                     				String inHouseRepairPromisedDate1="";
                     				
                     				if(!"".equals(asTransLogs1.get(i).get("inHouseRepairPromisedDate"))){
                     					inHouseRepairPromisedDate = transFormatYY.parse(String.valueOf(asTransLogs1.get(i).get("inHouseRepairPromisedDate")));
                     					inHouseRepairPromisedDate1 = transFormat1.format(inHouseRepairPromisedDate);
                     				}
                     				
                     				params.put("IN_HUSE_REPAIR_PROMIS_DT", inHouseRepairPromisedDate1);//asTransLogs
                     				
                     				
                     				if(asTransLogs1.get(i).get("inHouseRepairProductGroupCode")!=null){	
                     					params.put("IN_HUSE_REPAIR_GRP_CODE", String.valueOf(asTransLogs1.get(i).get("inHouseRepairProductGroupCode")));
                     				}else{
                     					params.put("IN_HUSE_REPAIR_GRP_CODE", "");
                     				}
                     				
                     				if(asTransLogs1.get(i).get("inHouseRepairProductCode")!=null){	
                     					params.put("IN_HUSE_REPAIR_PRODUCT_CODE", String.valueOf(asTransLogs1.get(i).get("inHouseRepairProductCode")));
                     				}else{
                     					params.put("IN_HUSE_REPAIR_PRODUCT_CODE", "");
                     				}
                     				
                     				if(asTransLogs1.get(i).get("inHouseRepairSerialNo")!=null){	
                     					params.put("IN_HUSE_REPAIR_SERIAL_NO", String.valueOf(asTransLogs1.get(i).get("inHouseRepairSerialNo")));
                     				}else{
                     					params.put("IN_HUSE_REPAIR_SERIAL_NO", "");
                     				}
                     				
                     				params.put("RESULT_CUST_NAME", asTransLogs1.get(i).get("resultCustName"));//asTransLogs
                     				
                     				
                     				if(asTransLogs1.get(i).get("resultIcMobileNo")!=null){	
                     					params.put("RESULT_MOBILE_NO", String.valueOf(asTransLogs1.get(i).get("resultIcMobileNo")));
                     				}else {
                     					params.put("RESULT_MOBILE_NO", "");
                     				}
                     				
                     				if(asTransLogs1.get(i).get("resultReportEmailNo")!=null){	
                     					params.put("RESULT_REP_EMAIL_NO", String.valueOf(asTransLogs1.get(i).get("resultReportEmailNo")));
                     				}else {
                     					params.put("RESULT_REP_EMAIL_NO", "");
                     				}
                     				
                     				if(asTransLogs1.get(i).get("resultAcceptanceName")!=null){	
                     					params.put("RESULT_ACEPT_NAME", String.valueOf(asTransLogs1.get(i).get("resultAcceptanceName")));
                     				}else {
                     					params.put("RESULT_ACEPT_NAME", "");
                     				}
                     				
                     				params.put("SGN_DT", asTransLogs1.get(i).get("signData"));//asTransLogs
                     				
                     				LOGGER.debug("params22222 값 : {}", params);
                     				
                     				Map<String, Object>   asResultInsert = new HashMap();
                     				
                     				asResultInsert.put("asResultM", params);
                     				asResultInsert.put("updator",getAsBasic.get("userId"));
                     				asResultInsert.put("add", paramsDetailCvt);				 
                     		
                     				LOGGER.debug("asResultInsert1111111111 값 : {}", asResultInsert);
                     				
                     				
                     				EgovMap  rtnValue = ASManagementListService.asResult_insert(asResultInsert);
                     
                     				if( null !=rtnValue){
                     					HashMap   spMap =(HashMap)rtnValue.get("spMap");
                     					LOGGER.debug("spMap :"+ spMap.toString());   
                     					if(!"000".equals(spMap.get("P_RESULT_MSG"))){
                     						rtnValue.put("logerr","Y");
                     					}
                     					servicesLogisticsPFCService.SP_SVC_LOGISTIC_REQUEST(spMap);
                     				}
				 }
				
			}
		}   
		
//		LinkedHashMap  asResultM = (LinkedHashMap)  params.get("asResultM");
//		List<EgovMap>  add			= (List<EgovMap>)  params.get("add");
//		EgovMap  rtnValue = ASManagementListService.asResult_insert(params);  
		
		
		
		
		
		
		
		
		
		
		// TODO : 리턴할 dto 구현.

		if (RegistrationConstants.IS_INSERT_AS_LOG) {
			MSvcLogApiService.updateSuccessASStatus(transactionId);
		}

		return ResponseEntity.ok(AfterServiceResultDto.create(transactionId));
	}
	
	
	
//	@ApiOperation(value = "Installation Result Registration", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
//	@RequestMapping(value = "/installationResult", method = RequestMethod.POST)
//	public ResponseEntity<InstallationResultDto> installationResult(@RequestBody  List<InstallationResultForm> installationResultForms)
//			throws Exception {		
//		
//		String transactionId = "";
//		List<Map<String, Object>> installTransLogs = null;
//		
//		if (RegistrationConstants.IS_INSERT_INSTALL_LOG) {
//			
//			installTransLogs = new ArrayList<>();
//			for(InstallationResultForm installService : installationResultForms){
//				installTransLogs.addAll(installService.createMap(installService));
//			}
//			
//			MSvcLogApiService.saveInstallServiceLogs(installTransLogs);
//			transactionId = MSvcLogApiService.get(0).getTransactionId();
//		}
//		
//
//		return ResponseEntity.ok(InstallationResultDto.create(transactionId));
//		
//							
//	}
	
	
	
	
/*	@ApiOperation(value = "Installation Result Registration", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	@RequestMapping(value = "/installationResult", method = RequestMethod.POST)
	public ResponseEntity<InstallationResultDto> installationResult(@RequestBody List<InstallationResultForm> installationResultForms)
			throws Exception {		
		String transactionId = "";
		List<Map<String, Object>> insTransLogs = null;
		
		
		insTransLogs = new ArrayList<>();
		for (InstallationResultForm insService : installationResultForms) {
			insTransLogs.addAll(insService.createMaps(insService));
		}
		
		
		for(int i=0 ; i < insTransLogs.size() ; i++ ){
			
			LOGGER.debug("asTransLogs11111 값 : {}", insTransLogs.get(i));
			Map<String, Object> params = insTransLogs.get(i);  
			
			if (RegistrationConstants.IS_INSERT_INSTALL_LOG) {
				MSvcLogApiService.saveInstallServiceLogs(params);
				
			}

			// business service....
//			// TODO : installResult 구현 필요.....
			MSvcLogApiService.insertInstallationResult(params);	
		
			// TODO : 리턴할 dto 구현.
//			transactionId = installationResultForms.getTransactionId();
			transactionId = (String) params.get("transactionId");
			
			if (RegistrationConstants.IS_INSERT_INSTALL_LOG) {
				MSvcLogApiService.updateSuccessInstallStatus(transactionId);
			}
			
		}	
	
		return ResponseEntity.ok(InstallationResultDto.create(transactionId));

	}*/


	
	
	
	@ApiOperation(value = "Installation Result Registration", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	@RequestMapping(value = "/installationResult", method = RequestMethod.POST)
	public ResponseEntity<InstallationResultDto> installationResult(@RequestBody List<InstallationResultForm> installationResultForms)
			throws Exception {		
		String transactionId = "";
		
		Calendar cal = Calendar.getInstance();
	    
		//현재 년도, 월, 일
		int year = cal.get ( cal.YEAR );
		int month = cal.get ( cal.MONTH ) + 1 ;
		int date = cal.get ( cal.DATE ) ;
		
		
		List<Map<String, Object>> insTransLogs = null;
		SessionVO sessionVO1 = new SessionVO();
		
		insTransLogs = new ArrayList<>();
		for (InstallationResultForm insService : installationResultForms) {
			insTransLogs.addAll(insService.createMaps(insService));
		}
		
		
		for(int i=0 ; i < insTransLogs.size() ; i++ ){
			
			LOGGER.debug("asTransLogs11111 값 : {}", insTransLogs.get(i));
			Map<String, Object> insApiresult = insTransLogs.get(i);  
			
			if (RegistrationConstants.IS_INSERT_INSTALL_LOG) {
				MSvcLogApiService.saveInstallServiceLogs(insApiresult);
			}
			
			
			
			
			
	
			
			// business service....
//			// TODO : installResult 구현 필요.....

			Map<String, Object> params = insTransLogs.get(i);  
			
		   int  isInsCnt =	installationResultListService.isInstallAlreadyResult(params);
			
		   
		   //이미 처리 되었는지 확인 
		   if(isInsCnt ==0 ){
			   
        			//api setting 
        			String statusId = "4"; //installStatus
        			
        			EgovMap installResult = MSvcLogApiService.getInstallResultByInstallEntryID(params);
        			params.put("installEntryId", installResult.get("installEntryId"));
        			
        			try{
        				
            			params.put("hidInstallation_AddDtl", installResult.get("addrDtl"));
            			params.put("hidInstallation_AreaID", installResult.get("areaId"));
            			
        			}catch(Exception e){
        				e.printStackTrace();
        			}
        	           
        			EgovMap orderInfo = installationResultListService.getOrderInfo(params);
        			
        			String userId = MSvcLogApiService.getUseridToMemid(params);
        			String installDate    = MSvcLogApiService.getInstallDate(insApiresult);
        			
        			sessionVO1.setUserId(Integer.parseInt(userId));
        			
        			params.put("installStatus",String.valueOf(statusId));//4
        			params.put("statusCodeId", Integer.parseInt(params.get("installStatus").toString()));
        			params.put("hidEntryId",String.valueOf(installResult.get("installEntryId")));
        			params.put("hidCustomerId",String.valueOf(installResult.get("custId")));
        			params.put("hidSalesOrderId",String.valueOf(installResult.get("salesOrdId")));
        			params.put("hidTaxInvDSalesOrderNo",String.valueOf(installResult.get("salesOrdNo"))); 
        			params.put("hidStockIsSirim",String.valueOf(installResult.get("isSirim")));
        			params.put("hidStockGrade",installResult.get("stkGrad"));
        			params.put("hidSirimTypeId",String.valueOf(installResult.get("stkCtgryId")));
        			params.put("hiddeninstallEntryNo",String.valueOf(installResult.get("installEntryNo")));
        			params.put("hidTradeLedger_InstallNo",String.valueOf(installResult.get("installEntryNo")));
        			
        			params.put("installDate" , installDate );
        			LOGGER.debug("installDate 값 : " + installDate);
        			params.put("CTID",String.valueOf(userId));
        			params.put("updator", String.valueOf(userId)); 
        			params.put("nextCallDate","01-01-1999"); 
        			params.put("refNo1","0"); 
        			params.put("refNo2","0"); 
        			params.put("codeId",String.valueOf(installResult.get("257")));
        			params.put("checkCommission", 1);
        			
        			if(orderInfo !=null){	
        				params.put("hidOutright_Price",CommonUtils.nvl(String.valueOf(orderInfo.get("c5"))));
        			}else {
        				params.put("hidOutright_Price", "0");
        			}
        			
        			params.put("hidAppTypeId",installResult.get("codeId"));
        			
        			//API in
        			params.put("hidStockIsSirim",String.valueOf(insTransLogs.get(i).get("sirimNo")));
        			params.put("hidSerialNo",String.valueOf(insTransLogs.get(i).get("serialNo")));
        			params.put("remark",insTransLogs.get(i).get("resultRemark"));
        			
        			LOGGER.debug("params11111 값 : {}", params);
        			Map rtnValue  =installationResultListService.insertInstallationResult(params,sessionVO1 );	
        			
        			
            			if( null !=rtnValue){
            				HashMap   spMap =(HashMap)rtnValue.get("spMap");
            				LOGGER.debug("spMap :"+ spMap.toString());   
            				if(!"000".equals(spMap.get("P_RESULT_MSG"))){
            					rtnValue.put("logerr","Y");
            				}else{
            						
            					
            						if (RegistrationConstants.IS_INSERT_INSTALL_LOG) {
            							MSvcLogApiService.updateSuccessInstallStatus(transactionId);
            						}
            					
            				}
            				servicesLogisticsPFCService.SP_SVC_LOGISTIC_REQUEST(spMap);
            			}
            			
            			
    		}else{
    			if (RegistrationConstants.IS_INSERT_INSTALL_LOG) {
					MSvcLogApiService.updateSuccessInstallStatus(String.valueOf(params.get("transactionId")));
				}
    		}	
		   
		}
		return ResponseEntity.ok(InstallationResultDto.create(transactionId));

	}
	
	
	@ApiOperation(value = "Display RC List", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	@RequestMapping(value = "/rcList", method = RequestMethod.POST)
	public ResponseEntity<List<RentalServiceCustomerDto>> rentalCustomerPaymentList(@RequestBody RentalServiceCustomerForm rentalForm)
			throws Exception {		
		String transactionId = "";
		
		Map<String, Object> map = new HashMap();
		
		map.put("userId" , String.valueOf(rentalForm.getUserId()));
		map.put("searchType" , String.valueOf(rentalForm.getSearchType()));
		map.put("searchKeyword" , String.valueOf(rentalForm.getSearchKeyword()));
		
		List<EgovMap> rcList = MSvcLogApiService.getRentalCustomerList(map);
		List<RentalServiceCustomerDto> list = null;
		
//		hsManualService.selecthSFilterUseHistorycall(params);
//		List<EgovMap> list = (List<EgovMap>)params.get("cv_1");
		
		if(rcList != null){
			list = rcList.stream().map(r -> RentalServiceCustomerDto.create(r))
					.collect(Collectors.toList());
		}

		return ResponseEntity.ok(list);

	}
	

	
	@ApiOperation(value = "Product Return Result Registration", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	@RequestMapping(value = "/productReturnResult", method = RequestMethod.POST)
	public ResponseEntity<ProductReturnResultDto> productReturnResult(@RequestBody List< ProductReturnResultForm> productReturnResultForm)
			throws Exception {		
		String transactionId = "";

		
		List<Map<String, Object>> prTransLogs = null;
		SessionVO sessionVO1 = new SessionVO();
		
		prTransLogs = new ArrayList<>();
		for (ProductReturnResultForm prService : productReturnResultForm) {
			prTransLogs.addAll(prService.createMaps(prService));
		}
		
		for(int i=0 ; i < prTransLogs.size() ; i++ ){
			
			LOGGER.debug("prTransLogs 값 : {}", prTransLogs.get(i));
			Map<String, Object> paramsTran = prTransLogs.get(i);  
			Map<String, Object>    cvMp = new HashMap<String, Object>(); 
			
	    	cvMp.put("stkRetnStusId",  			"4");  
	    	cvMp.put("stkRetnStkIsRet",  			"1");  
	    	cvMp.put("stkRetnRem",  			    String.valueOf(paramsTran.get("resultRemark"))); 
	    	cvMp.put("stkRetnResnId", 		    paramsTran.get("resultCode"));  
	    	cvMp.put("stkRetnCcId",  		     	paramsTran.get("ccCode")); 
	    	cvMp.put("stkRetnCrtUserId",         paramsTran.get("userId"));
	    	cvMp.put("stkRetnUpdUserId",        paramsTran.get("userId")); 
	    	cvMp.put("stkRetnResultIsSynch",   "0"); 
	    	cvMp.put("stkRetnAllowComm",  		"0"); 
	    	cvMp.put("stkRetnCtMemId",  		paramsTran.get("userId")); 
	    	cvMp.put("checkinDt",  					String.valueOf(paramsTran.get("checkInDate"))); 
	    	cvMp.put("checkinTm",  				String.valueOf(paramsTran.get("checkInTime"))); 
	    	cvMp.put("checkinGps",  				String.valueOf(paramsTran.get("checkInGps"))); 
	    	cvMp.put("signData",  					paramsTran.get("signData")); 
	    	cvMp.put("signRegDt",  					String.valueOf(paramsTran.get("signRegDate")));  
	    	cvMp.put("signRegTm",  				String.valueOf(paramsTran.get("signRegTime"))); 
	    	cvMp.put("ownerCode",                 String.valueOf(paramsTran.get("ownerCode"))); 
	    	cvMp.put("resultCustName",  		    String.valueOf(paramsTran.get("resultCustName"))); 
	    	cvMp.put("resultIcmobileNo",  		String.valueOf(paramsTran.get("resultIcMobileNo"))); 
	    	cvMp.put("resultRptEmailNo",  		String.valueOf(paramsTran.get("resultReportEmailNo"))); 
	    	cvMp.put("resultAceptName",  		String.valueOf(paramsTran.get("resultAcceptanceName"))); 
	    	cvMp.put("salesOrderNo",  String.valueOf(paramsTran.get("salesOrderNo"))); 
	    	cvMp.put("userId",  String.valueOf(paramsTran.get("userId"))); 
	    	cvMp.put("serviceNo",  String.valueOf(paramsTran.get("serviceNo"))); 
	    	cvMp.put("transactionId",  String.valueOf(paramsTran.get("transactionId"))); 
	    	
			
	    	EgovMap  rtnValue = MSvcLogApiService.productReturnResult(cvMp);
			
			if( null !=rtnValue){
				HashMap   spMap =(HashMap)rtnValue.get("spMap");
				LOGGER.debug("spMap :"+ spMap.toString());   
				if(!"000".equals(spMap.get("P_RESULT_MSG"))){
					rtnValue.put("logerr","Y");
				}
				servicesLogisticsPFCService.SP_SVC_LOGISTIC_REQUEST(spMap);
			}
			
		    /*
			transactionId = String.valueOf(params.get("transactionId"));
			
			if (RegistrationConstants.IS_INSERT_INSTALL_LOG) {
				MSvcLogApiService.updateSuccessInstallStatus(transactionId);
			}
			*/
			
		}
		
		
		return ResponseEntity.ok(ProductReturnResultDto.create(transactionId));
	}
	
	
	
	@ApiOperation(value = "Heart Service Re-Appointment Request", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	@RequestMapping(value = "/hSReAppointmtRequest", method = RequestMethod.POST)
	public ResponseEntity<HSReAppointmtRequestDto> hSReAppointmtRequest(@RequestBody HSReAppointmtRequestForm hSReAppointmtRequestForm)
			throws Exception {		
		String transactionId = "";

		Map<String, Object> params = HSReAppointmtRequestForm.createMaps(hSReAppointmtRequestForm);
		
		if (RegistrationConstants.IS_INSERT_HSRE_LOG) {
			MSvcLogApiService.saveHsReServiceLogs(params);
		}
		
		
//		// business service....
//		// TODO : installResult 구현 필요.....
		MSvcLogApiService.updateHsReAppointmentReturnResult(params);		

		
		// TODO : 리턴할 dto 구현.
//		transactionId = hSReAppointmtRequestForm.getTransactionId();
		
//		if (RegistrationConstants.IS_INSERT_HSRE_LOG) {
//			MSvcLogApiService.updateSuccessInstallStatus(transactionId);
//		}
		
		return ResponseEntity.ok(HSReAppointmtRequestDto.create(transactionId));

	}
	

	
	@ApiOperation(value = "Installation Re-Appointment Request", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	@RequestMapping(value = "/installReAppointmentRequest", method = RequestMethod.POST)
	public ResponseEntity<InstallReAppointmentRequestDto> installReAppointmentRequest(@RequestBody InstallReAppointmentRequestForm installReAppointmentRequestForm)
			throws Exception {		
		String transactionId = "";

		Map<String, Object> params = InstallReAppointmentRequestForm.createMaps(installReAppointmentRequestForm);
		
		if (RegistrationConstants.IS_INSERT_INSRE_LOG) {
			MSvcLogApiService.saveInsReServiceLogs(params);
		}
		
		
//		// business service....
//		// TODO : installResult 구현 필요.....
		
		String appTime = String.valueOf(params.get("appointmentTime"));
		int hour = Integer.parseInt(appTime.substring(0,2));

		if(hour >= 00 && hour <= 10){
			params.put("sesionCode","M");
		}else if(hour >= 10 && hour <= 14){
			params.put("sesionCode","A");
		}else if(hour >= 14 && hour <= 19){
			params.put("sesionCode","E");
		}else {
			params.put("sesionCode","O");
		}

		LOGGER.debug("sesionCode    값 >>>>>: {}", hour ,">>>>>", params.get("sesionCode"));
		
		MSvcLogApiService.updateInsReAppointmentReturnResult(params);		

		
		// TODO : 리턴할 dto 구현.
//		transactionId = installReAppointmentRequestForm.getTransactionId();
		
//		if (RegistrationConstants.IS_INSERT_INSRE_LOG) {
//			MSvcLogApiService.updateSuccessInstallStatus(transactionId);
//		}
		
		return ResponseEntity.ok(InstallReAppointmentRequestDto.create(transactionId));

	}
	
	
	
	@ApiOperation(value = "Product Return Re-Appointment Request", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	@RequestMapping(value = "/pRReAppointmentRequest", method = RequestMethod.POST)
	public ResponseEntity<PRReAppointmentRequestDto> pRReAppointmentRequest(@RequestBody  PRReAppointmentRequestForm pRReAppointmentRequestForm)
			throws Exception {		
		String transactionId = "";

		Map<String, Object> params = PRReAppointmentRequestForm.createMaps(pRReAppointmentRequestForm);
		
		if (RegistrationConstants.IS_INSERT_PRRE_LOG) {
			//MSvcLogApiService.savePrReServiceLogs(params);
		}
		
		MSvcLogApiService.updatePrReAppointmentReturnResult(params);		
		
		transactionId = pRReAppointmentRequestForm.getTransactionId();  
		
//		if (RegistrationConstants.IS_INSERT_INSTALL_LOG) {
//			MSvcLogApiService.updateSuccessInstallStatus(transactionId);
//		}
		
		return ResponseEntity.ok(PRReAppointmentRequestDto.create(transactionId));
	}
	
	
	
	//20171119 hash
	@ApiOperation(value = "After Service Re-Appointment Request", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	@RequestMapping(value = "/aSReAppointmentRequest", method = RequestMethod.POST)
	public ResponseEntity<ASReAppointmentRequestDto> aSReAppointmentRequest(@RequestBody ASReAppointmentRequestForm aSReAppointmentRequestForm)
			throws Exception {		
		String transactionId = "";
		SimpleDateFormat transFormat = new SimpleDateFormat("yyyyMMdd");
		SimpleDateFormat transFormat1 = new SimpleDateFormat("yyyy-MM-dd");
		DateFormat sdFormat = new SimpleDateFormat("ddMMyyyy");
		DateFormat sdFormat1 = new SimpleDateFormat("dd-MM-yyyy");
		
		DateFormat timeFormatOrg = new SimpleDateFormat("HHmm");
		DateFormat timeFormatNew = new SimpleDateFormat("HH:mm:ss.SSS");


		Map<String, Object> params = ASReAppointmentRequestForm.createMaps(aSReAppointmentRequestForm);
		
		if (RegistrationConstants.IS_INSERT_ASRE_LOG) {
			MSvcLogApiService.saveAsReServiceLogs(params);
		}
		
		
//		 business service STAT....18:22
//		// TODO : installResult 구현 필요...
		
			
		String userId = MSvcLogApiService.getUseridToMemid(params);
		Date appointmentTime = timeFormatOrg.parse((String) params.get("appointmentTime"));
		String appointmentTime1 = timeFormatNew.format(appointmentTime);
		
		
		String appTime = String.valueOf(params.get("appointmentTime"));
		int hour = Integer.parseInt(appTime.substring(0,2));

		if(hour >= 00 && hour <= 10){
			params.put("sesionCode","M");
		}else if(hour >= 10 && hour <= 14){
			params.put("sesionCode","A");
		}else if(hour >= 14 && hour <= 19){
			params.put("sesionCode","E");
		}else {
			params.put("sesionCode","E");
		}
		
		
		params.put("AS_APPNT_DT", sdFormat.format(transFormat.parse((String) params.get("appointmentDate"))));
		params.put("AS_APPNT_TM", String.valueOf(appointmentTime1));
		params.put("AS_SESION_CODE", params.get("sesionCode"));
		params.put("AS_NO", params.get("serviceNo"));
		params.put("AS_UPD_USER_ID", params.get("userId"));
		
		
		LOGGER.debug("params :"+ params.toString());
		//ASManagementListService.updateASEntry(params);
		
		MSvcLogApiService.updateReApointResult(params);		

//		 business service END ....
		
		
		// TODO : 리턴할 dto 구현.
//		transactionId = aSReAppointmentRequestForm.getTransactionId();
//		
//		if (RegistrationConstants.IS_INSERT_ASRE_LOG) {
//			MSvcLogApiService.updateSuccessAsReStatus(transactionId);
//		}
		
		return ResponseEntity.ok(ASReAppointmentRequestDto.create(transactionId));

	}
	
	
	
	@ApiOperation(value = "Heart Service Fail Job Request", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	@RequestMapping(value = "/hSFailJobRequest", method = RequestMethod.POST)
	public ResponseEntity<HSFailJobRequestDto> hSFailJobRequest(@RequestBody HSFailJobRequestForm hSFailJobRequestForm)
			throws Exception {		
		String transactionId = "";

		Map<String, Object> params = HSFailJobRequestForm.createMaps(hSFailJobRequestForm);
		
		if (RegistrationConstants.IS_INSERT_HSFAIL_LOG) {
			MSvcLogApiService.saveHsFailServiceLogs(params);
		}
		
		
//		// business service....
//		// TODO : installResult 구현 필요.....
		MSvcLogApiService.insertHsFailJobResult(params);		
		MSvcLogApiService.upDateHsFailJobResultM(params);
		
		// TODO : 리턴할 dto 구현.
//		transactionId = productReturnResultForm.getTransactionId();
		
//		if (RegistrationConstants.IS_INSERT_INSTALL_LOG) {
//			MSvcLogApiService.updateSuccessInstallStatus(transactionId);
//		}
		
		return ResponseEntity.ok(HSFailJobRequestDto.create(transactionId));

	}
	
	
	
	@ApiOperation(value = "After Service Fail Job Request", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	@RequestMapping(value = "/aSFailJobRequest", method = RequestMethod.POST)
	public ResponseEntity<ASFailJobRequestDto> aSFailJobRequest(@RequestBody ASFailJobRequestForm aSFailJobRequestForm)
			throws Exception {		
		String transactionId = "";

		Map<String, Object> params = ASFailJobRequestForm.createMaps(aSFailJobRequestForm);
		
		if (RegistrationConstants.IS_INSERT_ASFAIL_LOG) {
			MSvcLogApiService.saveAsFailServiceLogs(params);
		}
		
		
//		// business service....
//		// TODO : installResult 구현 필요.....
		MSvcLogApiService.insertAsFailJobResult(params);		
		MSvcLogApiService.upDatetAsFailJobResultM(params);		

		
		// TODO : 리턴할 dto 구현.
//		transactionId = aSFailJobRequestForm.getTransactionId();
		
//		if (RegistrationConstants.IS_INSERT_INSTALL_LOG) {
//			MSvcLogApiService.updateSuccessInstallStatus(transactionId);
//		}
		
		return ResponseEntity.ok(ASFailJobRequestDto.create(transactionId));

	}
	
	
	
	@ApiOperation(value = "Installation Fail Job Request", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	@RequestMapping(value = "/installFailJobRequest", method = RequestMethod.POST)
	public ResponseEntity<InstallFailJobRequestDto> installFailJobRequest(@RequestBody InstallFailJobRequestForm installFailJobRequestForm)
			throws Exception {		
		String transactionId = "";
		SessionVO sessionVO1 = new SessionVO();

		Map<String, Object> params = InstallFailJobRequestForm.createMaps(installFailJobRequestForm);
		
		LOGGER.debug("paramsMobile 값 : {}", params);
	
		if (RegistrationConstants.IS_INSERT_INSFAIL_LOG) {
			MSvcLogApiService.saveInsFailServiceLogs(params);
		}
		
		Calendar cal = Calendar.getInstance();
		int year = cal.get ( cal.YEAR );
		String month =String.format("%02d", cal.get(cal.MONTH) + 1) ;
		String date = String.format("%02d", cal.get ( cal.DATE )+1);
		String todayPlusOne = (String.valueOf(date) + '/'+String.valueOf(month)+ '/' + String.valueOf(year));
		LOGGER.debug("todayPlusOne 값 : " +todayPlusOne);
		 int  isInsCnt =	installationResultListService.isInstallAlreadyResult(params);
		 
		 //안들어 가있다면 
		 if(isInsCnt == 0){
			 String statusId = "21";
			 
			 EgovMap installResult = MSvcLogApiService.getInstallResultByInstallEntryID(params);
 			params.put("installEntryId", installResult.get("installEntryId"));
 			EgovMap orderInfo = installationResultListService.getOrderInfo(params);
 			
 			String userId = MSvcLogApiService.getUseridToMemid(params);
 			
 			sessionVO1.setUserId(Integer.parseInt(userId));
 			
 			params.put("installStatus",String.valueOf(statusId));//21
 			params.put("statusCodeId", Integer.parseInt(params.get("installStatus").toString()));
 			params.put("hidEntryId",String.valueOf(installResult.get("installEntryId")));
 			params.put("hidCustomerId",String.valueOf(installResult.get("custId")));
 			params.put("hidSalesOrderId",String.valueOf(installResult.get("salesOrdId")));
 			params.put("hidTaxInvDSalesOrderNo",String.valueOf(installResult.get("salesOrdNo"))); 
 			params.put("hidStockIsSirim",String.valueOf(installResult.get("isSirim")));
 			params.put("hidStockGrade",installResult.get("stkGrad"));
 			params.put("hidSirimTypeId",String.valueOf(installResult.get("stkCtgryId")));
 			params.put("hiddeninstallEntryNo",String.valueOf(installResult.get("installEntryNo")));
 			params.put("hidTradeLedger_InstallNo",String.valueOf(installResult.get("installEntryNo")));
 			params.put("hidCallType" ,"257"); //fail시 전화타입 257
 			params.put("CTID",String.valueOf(userId));
 			params.put("installDate","");
 			params.put("updator", String.valueOf(userId)); 
 			params.put("nextCallDate",todayPlusOne); 
 			params.put("refNo1","0"); 
 			params.put("refNo2","0"); 
 			params.put("codeId",String.valueOf(installResult.get("257")));
 			params.put("failReason" , String.valueOf(params.get("failReasonCode")));
 			if(orderInfo !=null){	
				params.put("hidOutright_Price",CommonUtils.nvl(String.valueOf(orderInfo.get("c5"))));
			}else {
				params.put("hidOutright_Price", "0");
			}
			
			params.put("hidAppTypeId",installResult.get("codeId"));
			/*params.put("hidStockIsSirim",String.valueOf(insTransLogs.get(i).get("sirimNo")));
			params.put("hidSerialNo",String.valueOf(insTransLogs.get(i).get("serialNo")));
			params.put("remark",insTransLogs.get(i).get("resultRemark"));*/
			
			LOGGER.debug("paramsJinmu 값 : {}", params);
			Map rtnValue  =installationResultListService.insertInstallationResult(params,sessionVO1 );	
			
			
    			if( null !=rtnValue){
    				HashMap   spMap =(HashMap)rtnValue.get("spMap");
    				LOGGER.debug("spMap :"+ spMap.toString());   
    				if(!"000".equals(spMap.get("P_RESULT_MSG"))){
    					rtnValue.put("logerr","Y");
    				}else{
    						
    						transactionId = String.valueOf(params.get("transactionId"));
    						if (RegistrationConstants.IS_INSERT_INSTALL_LOG) {
    							MSvcLogApiService.updateSuccessInstallStatus(transactionId);
    						}
    					
    				}
    				servicesLogisticsPFCService.SP_SVC_LOGISTIC_REQUEST(spMap);
    			}
 			
			 
		 }
		 else{
				if (RegistrationConstants.IS_INSERT_INSFAIL_LOG) {
					MSvcLogApiService.updateInsFailServiceLogs(params);
				}
			 
		 }
		 

		
		return ResponseEntity.ok(InstallFailJobRequestDto.create(transactionId));

	}
	
	
	
	@ApiOperation(value = "Product Return Fail Job Request", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	@RequestMapping(value = "/pRFailJobRequest", method = RequestMethod.POST)
	public ResponseEntity<PRFailJobRequestDto> pRReAppointmentRequest(@RequestBody PRFailJobRequestForm pRFailJobRequestForm)
			throws Exception {		
		String transactionId = "";

		Map<String, Object> params = PRFailJobRequestForm.createMaps(pRFailJobRequestForm);
		
		if (RegistrationConstants.IS_INSERT_PRFAIL_LOG) {
			//MSvcLogApiService.savePrFailServiceLogs(params);
		}
	       
		MSvcLogApiService.setPRFailJobRequest(params);		
  	
        transactionId = pRFailJobRequestForm.getTransactionId();
		
    	if (RegistrationConstants.IS_INSERT_PRFAIL_LOG) {
    			//MSvcLogApiService.updatePrFailServiceLogs(transactionId);
    	}
		
		return ResponseEntity.ok(PRFailJobRequestDto.create(transactionId));

	}
	
	
	
	

	@ApiOperation(value = "Cancel SMS Request", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	@RequestMapping(value = "/canSMSRequestRequest", method = RequestMethod.POST)
	public ResponseEntity<CanCelDto> canSMSRequestRequest(@RequestBody CanCelSmsForm canCelSmsForm)
			throws Exception {		
		String transactionId = "";
		SessionVO session = new SessionVO();		

		Map<String, Object> params = CanCelSmsForm.createMap(canCelSmsForm);
		List<String> mobileNumList = new ArrayList<String>();
		
		if (RegistrationConstants.IS_INSERT_PRFAIL_LOG) {
			MSvcLogApiService.saveCanSMSServiceLogs(params);
		}
		
		
//		// business service....
//		// TODO : installResult 구현 필요.....
		String cancReqNo  = "";
		cancReqNo = MSvcLogApiService.getcancReqNo(params);
		params.put("cancReqNo", cancReqNo);
		
		MSvcLogApiService.insertCancelSMS(params);		
		
		//send SMS
		SmsVO sms = new SmsVO(session.getUserId(), 975);
		
		String smsString = ("Do you really want to cancel for the current month Heart Service? " + "\n" + " HS Order Number :" + params.get("serviceNo")
		+  "\n" + " Cancel Request Number :" + cancReqNo );

		sms.setMessage(smsString);
		sms.setMobiles((String)canCelSmsForm.getReceiverTelNo());  

		LOGGER.debug("  : {}" , smsString);
		
		SmsResult smsResult = adaptorService.sendSMS(sms);
		
		// TODO : 리턴할 dto 구현.
//		transactionId = productReturnResultForm.getTransactionId();
		
//		if (RegistrationConstants.IS_INSERT_INSTALL_LOG) {
//			MSvcLogApiService.updateSuccessInstallStatus(transactionId);
//		}
		
		return ResponseEntity.ok(CanCelDto.create(transactionId));

	}
	
	
	
	
	
	
	
	@ApiOperation(value = "Service History List", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	@RequestMapping(value = "/serviceHistory", method = RequestMethod.POST)
	public ResponseEntity<List<ServiceHistoryDto>> serviceHistory(@RequestBody ServiceHistoryForm serviceHistoryForm)
			throws Exception {		
		String transactionId = "";

		Map<String, Object> params = ServiceHistoryForm.createMaps(serviceHistoryForm);
		
		List<EgovMap> headerList = MSvcLogApiService.serviceHistory(params);
		
		
		List<ServiceHistoryDto> hList = new ArrayList<>();
		for (int i = 0; i < headerList.size(); i++) {
			LOGGER.debug("Request Status headerList1111 값 : {}", headerList.get(i));
		}
		
		
			
			for (int i = 0; i < headerList.size(); i++) {

				hList = headerList.stream().map(r -> ServiceHistoryDto.create(r)).collect(Collectors.toList());

				for (int j = 0; j < hList.size(); j++) {
					Map<String, Object> tmpMap = headerList.get(j);

					LOGGER.debug("Request Status headerList1111 값 : {}", tmpMap.get("jobType"));
					
					if("AS".equals(tmpMap.get("jobType").toString())){
//						tmpMap.put("asResultId", params.get("asResultId"));
						List<EgovMap> historyParts = MSvcLogApiService.getAsPartsHistoryDList(tmpMap);

						List<ServiceHistoryPartDetailDto> partsList = historyParts.stream()
								.map(r -> ServiceHistoryPartDetailDto.create(r)).collect(Collectors.toList());
						hList.get(j).setPartList(partsList);
					}else{
						tmpMap.put("bsResultId", tmpMap.get("asResultId"));
						List<EgovMap> historyParts = MSvcLogApiService.getHsPartsHistoryDList(tmpMap);

						List<ServiceHistoryPartDetailDto> partsList = historyParts.stream()
								.map(r -> ServiceHistoryPartDetailDto.create(r)).collect(Collectors.toList());
						hList.get(j).setPartList(partsList);
					}
				}

				
				for (int k = 0; k < hList.size(); k++) {
					Map<String, Object> tmpMap1 = headerList.get(k);
					
					if("AS".equals(tmpMap1.get("jobType").toString())){
//						tmpMap1.put("searchStatus", params.get("searchStatus"));
						List<EgovMap> historyFilters = MSvcLogApiService.getAsFilterHistoryDList(tmpMap1);
						
						List<ServiceHistoryFilterDetailDto> filterList = historyFilters.stream()
								.map(r -> ServiceHistoryFilterDetailDto.create(r)).collect(Collectors.toList());
						hList.get(k).setFilterList(filterList);
					}else {
//						tmpMap1.put("searchStatus", params.get("searchStatus"));
						tmpMap1.put("bsResultId", tmpMap1.get("asResultId"));
						List<EgovMap> historyFilters = MSvcLogApiService.getHsFilterHistoryDList(tmpMap1);
						
						List<ServiceHistoryFilterDetailDto> filterList = historyFilters.stream()
								.map(r -> ServiceHistoryFilterDetailDto.create(r)).collect(Collectors.toList());
						hList.get(k).setFilterList(filterList);
					}

				}
			
			
		}

		return ResponseEntity.ok(hList);
		


	}
	
	@ApiOperation(value = "Outstanding Result", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	@RequestMapping(value = "/outstandingResult", method = RequestMethod.POST)
	public ResponseEntity<OutStandingResultVo> outStandingResult(@RequestBody RentalServiceCustomerForm rentalForm)
			throws Exception {		
		String transactionId = "";
		
		Map<String, Object> map = new HashMap();
		
		map.put("userId" , (String)rentalForm.getUserId());
		map.put("salesOrderNo" , (String)rentalForm.getSalesOrderNo());
		
		OutStandingResultVo orv = new OutStandingResultVo(); 
		
		
		Map<String, Object> rmap = MSvcLogApiService.selectOutstandingResult(map);
		
//		if (!rmap.isEmpty()){
//			LOGGER.debug(" :::: {}" ,rmap);
//		}
		
		if (rmap != null){
			LOGGER.debug(" :::: {}" ,rmap);
		}
		
		List<EgovMap> rcList = MSvcLogApiService.selectOutstandingResultDetailList(map);
		
		List<OutStandignResultDetail> list = rcList.stream().map(r -> OutStandignResultDetail.create(r))
				.collect(Collectors.toList());
		
		orv.setOsrd(list);

		//headSet
		if(rmap != null){
			orv.setSumRpf(String.valueOf(rmap.get("sumRpf")));
			orv.setSumRpt(String.valueOf(rmap.get("sumRpt")));
			orv.setSumRhf(String.valueOf(rmap.get("sumRhf")));
			orv.setSumRental(String.valueOf(rmap.get("sumRental")));
			orv.setSumAdjust(String.valueOf(rmap.get("sumAdjust")));
		}else {
			orv.setSumRpf("0");
			orv.setSumRpt("0");
			orv.setSumRhf("0");
			orv.setSumRental("0");
			orv.setSumAdjust("0");
		}
		

		
		/*
		List<OutStandignResultDetail> list = rcList.stream().map(r -> RentalServiceCustomerDto.create(r))
				.collect(Collectors.toList());
		*/
		return ResponseEntity.ok(orv);

	}
	
	
	
	
	@ApiOperation(value = "AS Request Result List", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	@RequestMapping(value = "/aSRequestResultList", method = RequestMethod.POST)
	public ResponseEntity<List<ASRequestResultDto>> aSRequestResultList(@RequestBody ASRequestResultForm aSRequestResultForm)
			throws Exception {		
		String transactionId = "";
		
		Map<String, Object> map = new HashMap();
		
		
		map.put("userId" , (String)aSRequestResultForm.getUserId());
		map.put("searchFromDate" , (String)aSRequestResultForm.getSearchFromDate());
		map.put("searchToDate" , (String)aSRequestResultForm.getSearchToDate());
		
		List<EgovMap> rcList = MSvcLogApiService.getASRequestResultList(map);
		
		List<ASRequestResultDto> list = rcList.stream().map(r -> ASRequestResultDto.create(r))
				.collect(Collectors.toList());

		return ResponseEntity.ok(list);

	}
	


	
	
	@ApiOperation(value = "AS Request Customer Search", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	@RequestMapping(value = "/aSRequestCust", method = RequestMethod.POST)
	public ResponseEntity<List<ASRequestCustDto>> aSRequestCust(@RequestBody ASRequestCustForm aSRequestCustForm)
			throws Exception {		
		String transactionId = "";
		
		Map<String, Object> map = new HashMap();
		
		map.put("userId" , (String)aSRequestCustForm.getUserId());
		map.put("searchType" , (String)aSRequestCustForm.getSearchType());
		map.put("searchKeyword" , (String)aSRequestCustForm.getSearchKeyword());
		
		List<EgovMap> rcList = MSvcLogApiService.getASRequestCustList(map);
		
		List<ASRequestCustDto> list = rcList.stream().map(r -> ASRequestCustDto.create(r))
				.collect(Collectors.toList());

		return ResponseEntity.ok(list);

	}
	
	
	
	
	//20171119 hash
	@ApiOperation(value = "AS Request Registration", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	@RequestMapping(value = "/aSRequestRegistration", method = RequestMethod.POST)
	public ResponseEntity<ASRequestRegistDto> aSRequestRegistration(@RequestBody ASRequestRegistForm aSRequestRegistForm)
			throws Exception {		

		String transactionId = "";
		Map<String, Object> params = ASRequestRegistForm.createMaps(aSRequestRegistForm);
		
		if (RegistrationConstants.IS_INSERT_ASRE_LOG) {
			MSvcLogApiService.saveASRequestRegistrationLogs(params);
		}
		
		
//		 business service STAT....18:22
//		// TODO : installResult 구현 필요.....
		LOGGER.debug("params :"+ params.toString());
		MSvcLogApiService.insertASRequestRegist(params);
//		 business service END ....
		
		
		// TODO : 리턴할 dto 구현.
//		transactionId = aSRequestRegistForm.getTransactionId();
//		
//		if (RegistrationConstants.IS_INSERT_ASRE_LOG) {
//			MSvcLogApiService.updateSuccessRequestRegiStatus(transactionId);
//		}
		
		return ResponseEntity.ok(ASRequestRegistDto.create(transactionId));

	}
	

	
}
