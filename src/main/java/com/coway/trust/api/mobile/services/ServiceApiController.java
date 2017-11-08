package com.coway.trust.api.mobile.services;

import java.util.ArrayList;
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
import com.coway.trust.api.mobile.logistics.stocktransfer.StockTransferRejectSMOReqForm;
import com.coway.trust.api.mobile.services.as.AfterServiceJobDto;
import com.coway.trust.api.mobile.services.as.AfterServiceJobForm;
import com.coway.trust.api.mobile.services.as.AfterServicePartsDto;
import com.coway.trust.api.mobile.services.as.AfterServicePartsForm;
import com.coway.trust.api.mobile.services.as.AfterServiceResultDto;
import com.coway.trust.api.mobile.services.as.AfterServiceResultForm;
import com.coway.trust.api.mobile.services.heartService.HeartServiceJobDto;
import com.coway.trust.api.mobile.services.heartService.HeartServiceJobForm;
import com.coway.trust.api.mobile.services.heartService.HeartServicePartsDto;
import com.coway.trust.api.mobile.services.heartService.HeartServicePartsForm;
import com.coway.trust.api.mobile.services.heartService.HeartServiceResultDto;
import com.coway.trust.api.mobile.services.heartService.HeartServiceResultForm;
import com.coway.trust.api.mobile.services.installation.InstallationJobDto;
import com.coway.trust.api.mobile.services.installation.InstallationJobForm;
import com.coway.trust.api.mobile.services.installation.InstallationResultDto;
import com.coway.trust.api.mobile.services.installation.InstallationResultForm;
import com.coway.trust.api.mobile.services.productRetrun.ProductRetrunJobDto;
import com.coway.trust.api.mobile.services.productRetrun.ProductRetrunJobForm;
import com.coway.trust.biz.services.mlog.MSvcLogApiService;
import com.coway.trust.cmmn.exception.PreconditionException;

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

			MSvcLogApiService.saveAfterServiceLogs(asTransLogs);

			transactionId = afterServiceForms.get(0).getTransactionId();
		}

		// business service....
		// TODO : heartService.xxxx 구현 필요.....
		
		//MSvcLogApiService.resultRegistration(asTransLogs);
		
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
	
	
	

}
