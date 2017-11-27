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
import com.coway.trust.api.mobile.services.productRetrun.ProductRetrunJobDto;
import com.coway.trust.api.mobile.services.productRetrun.ProductRetrunJobForm;
import com.coway.trust.api.mobile.services.productRetrun.ProductReturnResultDto;
import com.coway.trust.api.mobile.services.productRetrun.ProductReturnResultForm;
import com.coway.trust.api.mobile.services.sales.OutStandignResultDetail;
import com.coway.trust.api.mobile.services.sales.OutStandingResultVo;
import com.coway.trust.api.mobile.services.sales.RentalServiceCustomerDto;
import com.coway.trust.api.mobile.services.sales.RentalServiceCustomerForm;
import com.coway.trust.biz.services.as.ASManagementListService;
import com.coway.trust.biz.services.bs.HsManualService;
import com.coway.trust.biz.services.installation.InstallationResultListService;
import com.coway.trust.biz.services.mlog.MSvcLogApiService;
import com.coway.trust.cmmn.model.SessionVO;
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
	
	
	
	@ApiOperation(value = "Heart Service Job List 조회", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
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
	
	
	
	
	
	@ApiOperation(value = "AfterServiceJob List 조회", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
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
	
	
	
	
	
	@ApiOperation(value = "InstallationJob List 조회", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
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
	
	
	
	
	@ApiOperation(value = "ProductRetrunJob List 조회", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
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
	
	
	
	
	@ApiOperation(value = "Heart Service Parts List 조회", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
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
	
	
	
	
	@ApiOperation(value = "After Service Parts List 조회", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
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
	
	
	
	
	
//	@ApiOperation(value = "Heart", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
//	@RequestMapping(value = "/heartServiceResult", method = RequestMethod.POST)
//	public ResponseEntity<HeartServiceResultDto> hsRegistration (@RequestBody List<HeartServiceResultForm> heartForms) throws Exception {
//
//		String transactionId = "";
//		List<Map<String, Object>> heartLogs = null;
//		
//		// mobile 에서 받은 데이터를 로그 테이블에 insert......
//		LOGGER.debug("### INSERT_HEART_LOG : {}", RegistrationConstants.IS_INSERT_HEART_LOG);
//		LOGGER.debug("### TransactionId : {}", RegistrationConstants.IS_INSERT_HEART_LOG);
//		if (RegistrationConstants.IS_INSERT_HEART_LOG) {
//
//			heartLogs = new ArrayList<>();
//			for (HeartServiceResultForm heart : heartForms) {
//				heartLogs.addAll(heart.createMaps(heart));
//			}
//
//			// List<Map<String, Object>> heartLogs = heartForms.stream().flatMap(r -> r.createMaps(r))
//			// .collect(Collectors.toList());
//			MSvcLogApiService.saveHearLogs(heartLogs);
//
//			transactionId = heartForms.get(0).getTransactionId();
//		}
//
//		// business service....
//		// TODO : heartService.xxxx 구현 필요.....
//		
//		MSvcLogApiService.resultRegistration(heartLogs);
//		
//		// TODO : 리턴할 dto 구현.
//
//		if (RegistrationConstants.IS_INSERT_HEART_LOG) {
//			MSvcLogApiService.updateSuccessStatus(transactionId);
//		}
//
//		return ResponseEntity.ok(HeartServiceResultDto.create(transactionId));
//	}
//	
	
	
	
	
	
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

///***************///
		
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
				
				
				String userId = MSvcLogApiService.getUseridToMemid(params);
				sessionVO.setUserId(Integer.parseInt(userId));
				
				
				Map<String, Object> getHsBasic = MSvcLogApiService.getHsBasic(params);
				//api setting
				params.put("hidschdulId", getHsBasic.get("schdulId"));
				params.put("hidSalesOrdId", getHsBasic.get("salesOrdId"));
				params.put("hidCodyId", userId);
				params.put("settleDate", todate2);
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
				params.put("cmbCollectType",hsTransLogs1.get(i).get("rcCode"));
				
//				api 추가된거	
				params.put("temperateSetng",hsTransLogs1.get(i).get("temperatureSetting"));
				params.put("nextAppntDt",hsTransLogs1.get(i).get("nextAppointmentDate"));
				params.put("nextAppointmentTime",hsTransLogs1.get(i).get("nextAppointmentTime"));
				params.put("ownerCode",hsTransLogs1.get(i).get("ownerCode"));
				params.put("resultCustName",hsTransLogs1.get(i).get("resultCustName"));
				params.put("resultMobileNo",hsTransLogs1.get(i).get("resultIcMobileNo"));
				params.put("resultRptEmailNo",hsTransLogs1.get(i).get("resultReportEmailNo"));
				params.put("resultAceptName",hsTransLogs1.get(i).get("resultAcceptanceName"));
				params.put("sgnDt",hsTransLogs1.get(i).get("signData"));
//				params.put("remark",hsTransLogs1.get(i).get("signRegDate"));
//				params.put("remark",hsTransLogs1.get(i).get("signRegTime"));
//				params.put("remark",hsTransLogs1.get(i).get("transactionId"));
				
				
				
				LOGGER.debug("params22222 값 : {}", params);

				
// service to value setting				
				Map<String, Object>   asResultInsert = new HashMap();
				LOGGER.debug("hsResultInsert1111111111 값 : {}", asResultInsert);
				
				hsManualService.addIHsResult(params,paramsDetailList,sessionVO);
				

				
			}
		}   		
		
		
		
//***************///
		
		
		
		// TODO : 리턴할 dto 구현.

		if (RegistrationConstants.IS_INSERT_HEART_LOG) {
			MSvcLogApiService.updateSuccessStatus(transactionId);
		}

		return ResponseEntity.ok(HeartServiceResultDto.create(transactionId));
	}
	
	
	
	
	
	@ApiOperation(value = "AfterService Result Registration", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	@RequestMapping(value = "/afterServiceResult", method = RequestMethod.POST)
	public ResponseEntity<AfterServiceResultDto> asRegistration (@RequestBody List<AfterServiceResultForm> afterServiceForms) throws Exception {

		String transactionId = "";
		List<Map<String, Object>> asTransLogs = null;
		List<Map<String, Object>> asTransLogs1 = null;
		
		Calendar cal = Calendar.getInstance();
		 
		//현재 년도, 월, 일
		int year = cal.get ( cal.YEAR );
		int month = cal.get ( cal.MONTH ) + 1 ;
		int date = cal.get ( cal.DATE ) ;
			
		String todate2 = (String.valueOf(date) +String.valueOf(month) + String.valueOf(year));

		
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
				
				Map<String, Object>   afterServiceDetail = null;
//				Map<String, Object> paramsDetail = asTransLogs1.get(i).get("partList");
				
				List<Map<String, Object>> paramsDetail = AfterServiceResultDetailForm.createMaps((List<AfterServiceResultDetailForm>) asTransLogs1.get(i).get("partList"));

				Map<String , Object> paramsFilter = paramsDetail.get(i);
				paramsDetail.get(i).put("filterType", String.valueOf(paramsDetail.get(i).get("partsType")));
				paramsDetail.get(i).put("filterDesc", "aaaa-bbbb");
				
				
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
				
				paramsDetail.get(i).put("filterRemark", "1");
				paramsDetail.get(i).put("filterID", "1");
				paramsDetail.get(i).put("filterTotal", "1");
				
				
				Map<String, Object> params = asTransLogs1.get(i);  
//				Map<String, Object> servasMasterMap = asTransLogs.get(i);
				
				
				Map<String, Object> getAsBasic = MSvcLogApiService.getAsBasic(params);
				
				params.put("AS_SO_ID", getAsBasic.get("asSoId"));
				params.put("AS_CT_ID", getAsBasic.get("asCtId"));
				params.put("AS_RESULT_STUS_ID", '4');
				params.put("AS_FAIL_RESN_ID", getAsBasic.get("as_failResnId"));
				params.put("AS_REN_COLCT_ID", 0);
				params.put("AS_CMMS", getAsBasic.get("asCmms"));
				params.put("AS_BRNCH_ID", getAsBasic.get("asBrnchId"));
				params.put("AS_WH_ID", getAsBasic.get("asWhId"));
//				params.put("AS_RESULT_REM", getAsBasic.get("resultRemark"));
				params.put("AS_MALFUNC_ID", getAsBasic.get("asMalfuncId"));
				params.put("AS_MALFUNC_RESN_ID", getAsBasic.get("asMalfuncResnId"));
				params.put("AS_DEFECT_GRP_ID", 0);
				params.put("AS_DEFECT_PART_GRP_ID", 0);
//				params.put("AS_WORKMNSH", getAsBasic.get("asWorkmnsh"));
				params.put("AS_FILTER_AMT", getAsBasic.get("asFilterAmt"));
				params.put("AS_ACSRS_AMT", 0);
				params.put("AS_TOT_AMT", String.valueOf(getAsBasic.get("asTotAmt")));
				params.put("AS_RESULT_IS_SYNCH", 0);
				params.put("AS_RCALL", 0);
				params.put("AS_RESULT_STOCK_USE", getAsBasic.get("asResultStockUse"));
				params.put("AS_RESULT_TYPE_ID", 457);
				params.put("AS_RESULT_IS_CURR", 1);
				params.put("AS_RESULT_MTCH_ID", 0);
				params.put("AS_RESULT_NO_ERR", "");
				params.put("AS_ENTRY_POINT", 0);
				params.put("AS_WORKMNSH_TAX_CODE_ID", 0);
				params.put("AS_WORKMNSH_TXS", 0);
				params.put("AS_RESULT_MOBILE_ID", 0);
				params.put("AS_RESULT_NO", getAsBasic.get("asResultNo"));
				params.put("AS_RESULT_ID", getAsBasic.get("asResultId"));
				params.put("AS_NO", getAsBasic.get("asno"));
				params.put("HC_REM", " ");
				
				//004
				params.put("AS_ENTRY_ID", getAsBasic.get("asId"));//asTransLogs
				params.put("AS_NO", asTransLogs1.get(i).get("serviceNo"));//asTransLogs
				params.put("AS_DEFECT_TYPE_ID",  asTransLogs1.get(i).get("defectTypeId")); //asTransLogs
				params.put("AS_DEFECT_ID", asTransLogs1.get(i).get("defectId")); //asTransLogs
				params.put("AS_DEFECT_PART_ID", asTransLogs1.get(i).get("defectPartId")); //asTransLogs
				params.put("AS_DEFECT_DTL_RESN_ID", asTransLogs1.get(i).get("defectDetailReasonId"));//asTransLogs
				params.put("AS_SLUTN_RESN_ID", asTransLogs1.get(i).get("solutionReasonId"));//asTransLogs
				params.put("AS_SETL_DT", todate2);
				params.put("AS_SETL_TM", curTime);
				params.put("AS_WORKMNSH", asTransLogs1.get(i).get("labourCharge"));
				params.put("AS_RESULT_REM", asTransLogs1.get(i).get("resultRemark"));
				
				//
				params.put("IN_HUSE_REPAIR_REM", asTransLogs1.get(i).get("inHouseRepairRemark"));//asTransLogs
				params.put("IN_HUSE_REPAIR_REPLACE_YN", asTransLogs1.get(i).get("inHouseRepairReplacementYN"));//asTransLogs
				
				
/*				SimpleDateFormat transFormat = new SimpleDateFormat("dd-mm-yyyy");
				SimpleDateFormat transFormatYY = new SimpleDateFormat("yyyymmdd");
				SimpleDateFormat transFormatHH = new SimpleDateFormat("HHmmss");
				DateFormat sdFormat = new SimpleDateFormat("ddMMyyyy");
				DateFormat sdFormat1 = new SimpleDateFormat("dd-MM-yyyy");
				DateFormat sdFormat2 = new SimpleDateFormat("yyyymmdd");*/
				
				
				Date aaa = transFormatYY.parse(String.valueOf(asTransLogs1.get(i).get("inHouseRepairPromisedDate")));
				String bbb = transFormat1.format(aaa);
				
//				sdFormat2.format(date)();
//				
//				String aaa = sdFormat2.format(asTransLogs1.get(i).get("inHouseRepairPromisedDate"));
//				Date bbb  = sdFormat1.parse(aaa);
//				String ccc = sdFormat1.format(bbb);
				
//				Date inHouseRepairPromisedDate = sdFormat2.parse(sdFormat2.format(asTransLogs1.get(i).get("inHouseRepairPromisedDate")));
////				Date inHouseRepairPromisedDate1 = sdFormat.parse(inHouseRepairPromisedDate);
//				String inHouseRepairPromisedDate2 = sdFormat.format(inHouseRepairPromisedDate);
				
/*				params.put("IN_HUSE_REPAIR_PROMIS_DT", asTransLogs1.get(i).get("inHouseRepairPromisedDate"));//asTransLogs	*/
				
				params.put("IN_HUSE_REPAIR_PROMIS_DT", bbb);//asTransLogs
				params.put("IN_HUSE_REPAIR_GRP_CODE", asTransLogs1.get(i).get("inHouseRepairProductGroupCode"));//asTransLogs
				params.put("IN_HUSE_REPAIR_PRODUCT_CODE", asTransLogs1.get(i).get("inHouseRepairProductCode"));//asTransLogs
				params.put("IN_HUSE_REPAIR_SERIAL_NO", asTransLogs1.get(i).get("inHouseRepairSerialNo"));//asTransLogs
				params.put("RESULT_CUST_NAME", asTransLogs1.get(i).get("resultCustName"));//asTransLogs
				params.put("RESULT_MOBILE_NO", asTransLogs1.get(i).get("resultIcMobileNo"));//asTransLogs
				params.put("RESULT_REP_EMAIL_NO", asTransLogs1.get(i).get("resultReportEmailNo"));//asTransLogs
				params.put("RESULT_ACEPT_NAME", asTransLogs1.get(i).get("resultAcceptanceName"));//asTransLogs
				params.put("SGN_DT", asTransLogs1.get(i).get("signData"));//asTransLogs
				
				LOGGER.debug("params22222 값 : {}", params);
				
				Map<String, Object>   asResultInsert = new HashMap();
				
				asResultInsert.put("asResultM", params);
				asResultInsert.put("updator",getAsBasic.get("userId"));
				asResultInsert.put("add", paramsDetail);				 
				
				LOGGER.debug("asResultInsert1111111111 값 : {}", asResultInsert);
				
				ASManagementListService.asResult_insert(asResultInsert);
				

				
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
		String todate2 = (String.valueOf(date) +String.valueOf(month) + String.valueOf(year));
		
		
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
			//api setting 
			String statusId = "4"; //installStatus
			
			EgovMap installResult = MSvcLogApiService.getInstallResultByInstallEntryID(params);
			String userId = MSvcLogApiService.getUseridToMemid(params);
			
			sessionVO1.setUserId(Integer.parseInt(userId));
			
			params.put("installStatus",statusId);//4
			params.put("statusCodeId", Integer.parseInt(params.get("installStatus").toString()));
			params.put("hidEntryId",installResult.get("installEntryId"));
			params.put("hidCustomerId",installResult.get("custId"));
			params.put("hidSalesOrderId",installResult.get("salesOrdId"));
			params.put("hidStockIsSirim",installResult.get("isSirim"));
			params.put("hidStockGrade",installResult.get("stkGrad"));
			params.put("hidSirimTypeId",installResult.get("stkCtgryId"));
			params.put("hiddeninstallEntryNo",installResult.get("installEntryNo"));
			params.put("CTID",userId);
			params.put("installDate",todate2);
			params.put("updator", userId); 
			params.put("nextCallDate","01-01-1999"); 
			params.put("refNo1","0"); 
			params.put("refNo2","0"); 

			
			//API in
			params.put("hidSirimNo",insTransLogs.get(i).get("sirimNo"));
			params.put("hidSerialNo",insTransLogs.get(i).get("serialNo"));
			params.put("remark",insTransLogs.get(i).get("resultRemark"));
			
			LOGGER.debug("params11111 값 : {}", params);
			installationResultListService.insertInstallationResult(params,sessionVO1 );	

			
			// TODO : 리턴할 dto 구현.
//			transactionId = installationResultForms.getTransactionId();
			transactionId = (String) params.get("transactionId");
			
			if (RegistrationConstants.IS_INSERT_INSTALL_LOG) {
				MSvcLogApiService.updateSuccessInstallStatus(transactionId);
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
		
		map.put("userId" , (String)rentalForm.getUserId());
		map.put("searchType" , (String)rentalForm.getSerchType());
		map.put("searchKeyword" , (String)rentalForm.getSearchKeyword());
		
		List<EgovMap> rcList = MSvcLogApiService.getRentalCustomerList(map);
		
		List<RentalServiceCustomerDto> list = rcList.stream().map(r -> RentalServiceCustomerDto.create(r))
				.collect(Collectors.toList());

		return ResponseEntity.ok(list);

	}
	

	
	@ApiOperation(value = "Product Return Result Registration", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	@RequestMapping(value = "/productReturnResult", method = RequestMethod.POST)
	public ResponseEntity<ProductReturnResultDto> productReturnResult(@RequestBody ProductReturnResultForm productReturnResultForm)
			throws Exception {		
		String transactionId = "";

		Map<String, Object> params = ProductReturnResultForm.createMaps(productReturnResultForm);
		
//		if (RegistrationConstants.IS_INSERT_INSTALL_LOG) {
//			MSvcLogApiService.saveInstallServiceLogs(params);
//		}
		
		
//		// business service....
//		// TODO : installResult 구현 필요.....
		MSvcLogApiService.insertProductReturnResult(params);		

		
		// TODO : 리턴할 dto 구현.
		transactionId = productReturnResultForm.getTransactionId();
		
//		if (RegistrationConstants.IS_INSERT_INSTALL_LOG) {
//			MSvcLogApiService.updateSuccessInstallStatus(transactionId);
//		}
		
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
	public ResponseEntity<PRReAppointmentRequestDto> pRReAppointmentRequest(@RequestBody ProductReturnResultForm productReturnResultForm)
			throws Exception {		
		String transactionId = "";

		Map<String, Object> params = ProductReturnResultForm.createMaps(productReturnResultForm);
		
		if (RegistrationConstants.IS_INSERT_PRRE_LOG) {
			MSvcLogApiService.savePrReServiceLogs(params);
		}
		
		
//		// business service....
//		// TODO : installResult 구현 필요.....
//		MSvcLogApiService.insertProductReturnResult(params);		

		
		// TODO : 리턴할 dto 구현.
		transactionId = productReturnResultForm.getTransactionId();
		
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
//		// TODO : installResult 구현 필요.....
		
		params.put("orderNo", params.get("salesOrderNo"));
		EgovMap as_ord_basicInfo = MSvcLogApiService.selectAsBasicInfo(params);		
		String userId = MSvcLogApiService.getUseridToMemid(params);
		String  AS_REQST_DT = transFormat.format(as_ord_basicInfo.get("asReqstDt"));
		String  AS_REQST_DT1  = sdFormat.format(transFormat.parse(AS_REQST_DT));
		

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
			params.put("sesionCode","O");
		}
		
		
//		Date appointmentTime = timeFormatOrg.parse(String.valueOf(params.get("appointmentTime")));
//		String appointmentTime1 = timeFormatNew.format(appointmentTime);
		
		params.put("AS_ID", as_ord_basicInfo.get("asId"));
		params.put("AS_MEM_ID", userId);
		params.put("AS_MEM_GRP", as_ord_basicInfo.get("asMemGrp"));
//		params.put("AS_REQST_DT", sdFormat.format(transFormat.parse(as_ord_basicInfo.get("asReqstDt").toString())));
		params.put("AS_REQST_DT", AS_REQST_DT1);
		params.put("AS_REQST_TM", as_ord_basicInfo.get("asReqstTm"));
		params.put("AS_APPNT_DT", sdFormat.format(transFormat.parse((String) params.get("appointmentDate"))));
		params.put("AS_APPNT_TM", String.valueOf(appointmentTime1));
		params.put("AS_BRNCH_ID", as_ord_basicInfo.get("asBrnchId"));
		params.put("AS_MALFUNC_ID", as_ord_basicInfo.get("asMalfuncId"));
		params.put("AS_MALFUNC_RESN_ID", as_ord_basicInfo.get("asMalfuncResnId"));
		params.put("AS_REM_REQSTER", as_ord_basicInfo.get("asRemReqster"));
		params.put("AS_REM_REQSTER_CNTC", as_ord_basicInfo.get("asRemReqsterCntc"));
		params.put("AS_REQSTER_TYPE_ID", as_ord_basicInfo.get("asReqsterTypeId"));
		params.put("AS_IS_BS_WITHIN_30DAYS", as_ord_basicInfo.get("asIsBsWithin30days"));
		params.put("AS_ALLOW_COMM", as_ord_basicInfo.get("asAllowComm"));
		params.put("AS_REM_ADD_CNTC", as_ord_basicInfo.get("asRemAddCntc"));
		params.put("AS_REM_REQSTER_CNTC_SMS", as_ord_basicInfo.get("asRemReqsterCntcSms"));
		params.put("AS_REM_ADD_CNTC_SMS", as_ord_basicInfo.get("asRemAddCntcSms"));
		params.put("AS_SESION_CODE", params.get("sesionCode"));
//		params.put("AS_SESION_CODE", as_ord_basicInfo.get("asSesionCode"));
		params.put("CALL_MEMBER", as_ord_basicInfo.get("callMember"));
		params.put("REF_REQUEST", as_ord_basicInfo.get("refRequest"));

		
		LOGGER.debug("params :"+ params.toString());
		ASManagementListService.updateASEntry(params);
		
//		MSvcLogApiService.updateReApointResult(params);		

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

		Map<String, Object> params = InstallFailJobRequestForm.createMaps(installFailJobRequestForm);
		
		if (RegistrationConstants.IS_INSERT_INSFAIL_LOG) {
			MSvcLogApiService.saveInsFailServiceLogs(params);
		}
		
		
//		// business service....
//		// TODO : installResult 구현 필요.....
		MSvcLogApiService.insertInstallFailJobResult(params);		
		MSvcLogApiService.upDateInstallFailJobResultM(params);		

		
		// TODO : 리턴할 dto 구현.
//		transactionId = productReturnResultForm.getTransactionId();
		
//		if (RegistrationConstants.IS_INSERT_INSTALL_LOG) {
//			MSvcLogApiService.updateSuccessInstallStatus(transactionId);
//		}
		
		return ResponseEntity.ok(InstallFailJobRequestDto.create(transactionId));

	}
	
	
	
	@ApiOperation(value = "Product Return Fail Job Request", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	@RequestMapping(value = "/pRFailJobRequest", method = RequestMethod.POST)
	public ResponseEntity<PRFailJobRequestDto> pRReAppointmentRequest(@RequestBody PRFailJobRequestForm pRFailJobRequestForm)
			throws Exception {		
		String transactionId = "";

		Map<String, Object> params = PRFailJobRequestForm.createMaps(pRFailJobRequestForm);
		
		if (RegistrationConstants.IS_INSERT_PRFAIL_LOG) {
			MSvcLogApiService.savePrFailServiceLogs(params);
		}
		
		
//		// business service....
//		// TODO : installResult 구현 필요.....
		MSvcLogApiService.insertProductReturnResult(params);		

		
		// TODO : 리턴할 dto 구현.
//		transactionId = productReturnResultForm.getTransactionId();
		
//		if (RegistrationConstants.IS_INSERT_INSTALL_LOG) {
//			MSvcLogApiService.updateSuccessInstallStatus(transactionId);
//		}
		
		return ResponseEntity.ok(PRFailJobRequestDto.create(transactionId));

	}
	
	
	
	

	@ApiOperation(value = "Cancel SMS Request", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	@RequestMapping(value = "/canSMSRequestRequest", method = RequestMethod.POST)
	public ResponseEntity<CanCelDto> canSMSRequestRequest(@RequestBody CanCelSmsForm canCelSmsForm)
			throws Exception {		
		String transactionId = "";

		Map<String, Object> params = CanCelSmsForm.createMap(canCelSmsForm);
		
		if (RegistrationConstants.IS_INSERT_PRFAIL_LOG) {
			MSvcLogApiService.saveCanSMSServiceLogs(params);
		}
		
		
//		// business service....
//		// TODO : installResult 구현 필요.....
//		MSvcLogApiService.insertProductReturnResult(params);		

		
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
//						tmpMap.put("bsResultId", params.get("bsResultId"));
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
		
		if (!rmap.isEmpty()){
			LOGGER.debug(" :::: {}" ,rmap);
		}
		
		List<EgovMap> rcList = MSvcLogApiService.selectOutstandingResultDetailList(map);
		
		List<OutStandignResultDetail> list = rcList.stream().map(r -> OutStandignResultDetail.create(r))
				.collect(Collectors.toList());
		
		orv.setOsrd(list);
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
