package com.coway.trust.api.mobile.services;

import java.util.ArrayList;
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
import com.coway.trust.api.mobile.logistics.ctcodylist.DisplayCt_CodyListDto;
import com.coway.trust.api.mobile.logistics.stocktransfer.StockTransferRejectSMOReqForm;
import com.coway.trust.api.mobile.services.as.ASFailJobRequestDto;
import com.coway.trust.api.mobile.services.as.ASFailJobRequestForm;
import com.coway.trust.api.mobile.services.as.ASReAppointmentRequestDto;
import com.coway.trust.api.mobile.services.as.ASReAppointmentRequestForm;
import com.coway.trust.api.mobile.services.as.AfterServiceJobDto;
import com.coway.trust.api.mobile.services.as.AfterServiceJobForm;
import com.coway.trust.api.mobile.services.as.AfterServicePartsDto;
import com.coway.trust.api.mobile.services.as.AfterServicePartsForm;
import com.coway.trust.api.mobile.services.as.AfterServiceResultDto;
import com.coway.trust.api.mobile.services.as.AfterServiceResultForm;
import com.coway.trust.api.mobile.services.heartService.HSFailJobRequestDto;
import com.coway.trust.api.mobile.services.heartService.HSFailJobRequestForm;
import com.coway.trust.api.mobile.services.heartService.HSReAppointmtRequestDto;
import com.coway.trust.api.mobile.services.heartService.HSReAppointmtRequestForm;
import com.coway.trust.api.mobile.services.heartService.HeartServiceJobDto;
import com.coway.trust.api.mobile.services.heartService.HeartServiceJobForm;
import com.coway.trust.api.mobile.services.heartService.HeartServicePartsDto;
import com.coway.trust.api.mobile.services.heartService.HeartServicePartsForm;
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
import com.coway.trust.api.mobile.services.sales.RentalServiceCustomerDto;
import com.coway.trust.api.mobile.services.sales.RentalServiceCustomerForm;
import com.coway.trust.api.mobile.services.productRetrun.ProductReturnResultDto;
import com.coway.trust.api.mobile.services.productRetrun.ProductReturnResultForm;
import com.coway.trust.biz.services.as.ASManagementListService;
import com.coway.trust.biz.services.mlog.MSvcLogApiService;

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
	
	
	
	
	
	@ApiOperation(value = "Heart", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	@RequestMapping(value = "/heartServiceResult", method = RequestMethod.POST)
	public ResponseEntity<HeartServiceResultDto> hsRegistration (@RequestBody List<HeartServiceResultForm> heartForms) throws Exception {

		String transactionId = "";
		List<Map<String, Object>> heartLogs = null;
		
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

		// business service....
		// TODO : heartService.xxxx 구현 필요.....
		
		MSvcLogApiService.resultRegistration(heartLogs);
		
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
		
		// mobile 에서 받은 데이터를 로그 테이블에 insert......
		LOGGER.debug("### IS_INSERT_AS_LOG : {}", RegistrationConstants.IS_INSERT_AS_LOG);
		LOGGER.debug("### TransactionId : {}", RegistrationConstants.IS_INSERT_AS_LOG);

		if (RegistrationConstants.IS_INSERT_AS_LOG) {

			asTransLogs = new ArrayList<>();
			for (AfterServiceResultForm afterService : afterServiceForms) {
				asTransLogs.addAll(afterService.createMaps(afterService));
			}

//			MSvcLogApiService.saveAfterServiceLogs(asTransLogs);

			transactionId = afterServiceForms.get(0).getTransactionId();
		}
		

		// business service....
		// TODO : heartService.xxxx 구현 필요.....		
//		MSvcLogApiService.aSresultRegistration(asTransLogs);
		if(asTransLogs.size()> 0) {
			for(int i=0 ; i < asTransLogs.size() ; i++ ){
				Map<String, Object> asMasterMap = asTransLogs.get(i);
				Map<String, Object> servasMasterMap = asTransLogs.get(i);
				asMasterMap.put("AS_ENTRY_ID", asMasterMap.get(""));
				

			
			
			
			
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
	
	
	
	
	@ApiOperation(value = "Installation Result Registration", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	@RequestMapping(value = "/installationResult", method = RequestMethod.POST)
	public ResponseEntity<InstallationResultDto> installationResult(@RequestBody InstallationResultForm installationResultForm)
			throws Exception {		
		String transactionId = "";

		Map<String, Object> params = InstallationResultForm.createMaps(installationResultForm);
		
		if (RegistrationConstants.IS_INSERT_INSTALL_LOG) {
			MSvcLogApiService.saveInstallServiceLogs(params);
		}
		
		
//		// business service....
//		// TODO : installResult 구현 필요.....
		MSvcLogApiService.insertInstallationResult(params);		

		
		// TODO : 리턴할 dto 구현.
		transactionId = installationResultForm.getTransactionId();
		
		if (RegistrationConstants.IS_INSERT_INSTALL_LOG) {
			MSvcLogApiService.updateSuccessInstallStatus(transactionId);
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
		
//		if (RegistrationConstants.IS_INSERT_INSTALL_LOG) {
//			MSvcLogApiService.saveInstallServiceLogs(params);
//		}
		
		
//		// business service....
//		// TODO : installResult 구현 필요.....
		MSvcLogApiService.insertProductReturnResult(params);		

		
		// TODO : 리턴할 dto 구현.
//		transactionId = hSReAppointmtRequestForm.getTransactionId();
		
//		if (RegistrationConstants.IS_INSERT_INSTALL_LOG) {
//			MSvcLogApiService.updateSuccessInstallStatus(transactionId);
//		}
		
		return ResponseEntity.ok(HSReAppointmtRequestDto.create(transactionId));

	}
	

	
	
	@ApiOperation(value = "After Service Re-Appointment Request", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	@RequestMapping(value = "/aSReAppointmentRequest", method = RequestMethod.POST)
	public ResponseEntity<ASReAppointmentRequestDto> aSReAppointmentRequest(@RequestBody ASReAppointmentRequestForm aSReAppointmentRequestForm)
			throws Exception {		
		String transactionId = "";

		Map<String, Object> params = ASReAppointmentRequestForm.createMaps(aSReAppointmentRequestForm);
		
//		if (RegistrationConstants.IS_INSERT_INSTALL_LOG) {
//			MSvcLogApiService.saveInstallServiceLogs(params);
//		}
		
		
//		// business service....
//		// TODO : installResult 구현 필요.....
		MSvcLogApiService.insertProductReturnResult(params);		

		
		// TODO : 리턴할 dto 구현.
//		transactionId = productReturnResultForm.getTransactionId();
		
//		if (RegistrationConstants.IS_INSERT_INSTALL_LOG) {
//			MSvcLogApiService.updateSuccessInstallStatus(transactionId);
//		}
		
		return ResponseEntity.ok(ASReAppointmentRequestDto.create(transactionId));

	}
	
	
	
	
	@ApiOperation(value = "Installation Re-Appointment Request", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	@RequestMapping(value = "/installReAppointmentRequest", method = RequestMethod.POST)
	public ResponseEntity<InstallReAppointmentRequestDto> installReAppointmentRequest(@RequestBody InstallReAppointmentRequestForm installReAppointmentRequestForm)
			throws Exception {		
		String transactionId = "";

		Map<String, Object> params = InstallReAppointmentRequestForm.createMaps(installReAppointmentRequestForm);
		
//		if (RegistrationConstants.IS_INSERT_INSTALL_LOG) {
//			MSvcLogApiService.saveInstallServiceLogs(params);
//		}
		
		
//		// business service....
//		// TODO : installResult 구현 필요.....
		MSvcLogApiService.insertProductReturnResult(params);		

		
		// TODO : 리턴할 dto 구현.
//		transactionId = installReAppointmentRequestForm.getTransactionId();
		
//		if (RegistrationConstants.IS_INSERT_INSTALL_LOG) {
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
		
		return ResponseEntity.ok(PRReAppointmentRequestDto.create(transactionId));

	}
	
	
	
	
	////
	
	
	
	@ApiOperation(value = "Heart Service Fail Job Request", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	@RequestMapping(value = "/hSFailJobRequest", method = RequestMethod.POST)
	public ResponseEntity<HSFailJobRequestDto> hSFailJobRequest(@RequestBody HSFailJobRequestForm hSFailJobRequestForm)
			throws Exception {		
		String transactionId = "";

		Map<String, Object> params = HSFailJobRequestForm.createMaps(hSFailJobRequestForm);
		
//		if (RegistrationConstants.IS_INSERT_INSTALL_LOG) {
//			MSvcLogApiService.saveInstallServiceLogs(params);
//		}
		
		
//		// business service....
//		// TODO : installResult 구현 필요.....
		MSvcLogApiService.insertProductReturnResult(params);		

		
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
		
//		if (RegistrationConstants.IS_INSERT_INSTALL_LOG) {
//			MSvcLogApiService.saveInstallServiceLogs(params);
//		}
		
		
//		// business service....
//		// TODO : installResult 구현 필요.....
		MSvcLogApiService.insertProductReturnResult(params);		

		
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
		
//		if (RegistrationConstants.IS_INSERT_INSTALL_LOG) {
//			MSvcLogApiService.saveInstallServiceLogs(params);
//		}
		
		
//		// business service....
//		// TODO : installResult 구현 필요.....
		MSvcLogApiService.insertProductReturnResult(params);		

		
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
		
//		if (RegistrationConstants.IS_INSERT_INSTALL_LOG) {
//			MSvcLogApiService.saveInstallServiceLogs(params);
//		}
		
		
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
	
	
	
	
	
	
}
