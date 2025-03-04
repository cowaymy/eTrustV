package com.coway.trust.api.mobile.services;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import javax.annotation.Resource;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
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
import com.coway.trust.api.mobile.services.as.AfterServiceResultDto;
import com.coway.trust.api.mobile.services.as.AfterServiceResultForm;
import com.coway.trust.api.mobile.services.as.HomecareAfterServiceApiDto;
import com.coway.trust.api.mobile.services.as.HomecareAfterServiceApiForm;
import com.coway.trust.api.mobile.services.as.SyncIhrApiDto;
import com.coway.trust.api.mobile.services.as.SyncIhrApiForm;
import com.coway.trust.api.mobile.services.asFromCody.AsFromCodyDto;
import com.coway.trust.api.mobile.services.asFromCody.AsFromCodyForm;
import com.coway.trust.api.mobile.services.serviceMileage.ServiceMileageForm;
import com.coway.trust.api.mobile.services.cancelSms.CanCelDto;
import com.coway.trust.api.mobile.services.cancelSms.CanCelSmsForm;
import com.coway.trust.api.mobile.services.gps.UpdateGPSForm;
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
import com.coway.trust.api.mobile.services.history.AsDetailDto;
import com.coway.trust.api.mobile.services.history.AsDetailForm;
import com.coway.trust.api.mobile.services.history.ServiceHistoryDto;
import com.coway.trust.api.mobile.services.history.ServiceHistoryFilterDetailDto;
import com.coway.trust.api.mobile.services.history.ServiceHistoryForm;
import com.coway.trust.api.mobile.services.history.ServiceHistoryPartDetailDto;
import com.coway.trust.api.mobile.services.installation.HomecareServiceApiDto;
import com.coway.trust.api.mobile.services.installation.HomecareServiceApiForm;
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
import com.coway.trust.biz.logistics.returnusedparts.ReturnUsedPartsService;
import com.coway.trust.biz.services.as.ASManagementListService;
import com.coway.trust.biz.services.as.AsFromCodyApiService;
import com.coway.trust.biz.services.as.IhrApiService;
import com.coway.trust.biz.services.as.ServicesLogisticsPFCService;
import com.coway.trust.biz.services.bs.HsManualService;
import com.coway.trust.biz.services.installation.InstallationResultListService;
import com.coway.trust.biz.services.mlog.MSvcLogApiService;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.cmmn.model.SmsVO;
import com.google.gson.JsonObject;
//import com.ibm.icu.text.DateFormat;
//import com.ibm.icu.text.SimpleDateFormat;
import java.text.DateFormat;
import java.text.SimpleDateFormat;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import com.coway.trust.biz.services.installation.ServiceApiInstallationService;
import com.coway.trust.biz.services.bs.ServiceApiHSService;
import com.coway.trust.biz.services.homecareServiceApi.HomecareServiceApiService;
import com.coway.trust.biz.services.as.ServiceApiASService;
import com.coway.trust.biz.services.as.ServiceMileageApiService;
import com.coway.trust.biz.services.pr.ServiceApiPRService;

import com.coway.trust.api.mobile.services.careService.CareServiceJobDto;
import com.coway.trust.api.mobile.services.careService.CareServiceJobForm;
import com.coway.trust.api.mobile.services.careService.CareServicePartsDto;
import com.coway.trust.api.mobile.services.careService.HcServiceJobDto;
import com.coway.trust.api.mobile.services.careService.HcServiceJobForm;
import com.coway.trust.api.mobile.services.careService.CareServicePartsForm;
import com.coway.trust.api.mobile.services.careService.RelateOrderListDto;
import com.coway.trust.api.mobile.services.careService.RelateOrderListForm;
import com.coway.trust.api.mobile.services.careService.SalesDetailDto;
import com.coway.trust.api.mobile.services.dtAs.DtAfterServiceJobDto;
import com.coway.trust.api.mobile.services.dtAs.DtAfterServiceJobForm;
import com.coway.trust.api.mobile.services.dtAs.DtAfterServicePartsDto;
import com.coway.trust.api.mobile.services.dtAs.DtAfterServicePartsForm;
import com.coway.trust.api.mobile.services.dtInstallation.DtInstallationJobDto;
import com.coway.trust.api.mobile.services.dtInstallation.DtInstallationJobForm;
import com.coway.trust.api.mobile.services.dtProductRetrun.DtProductRetrunJobDto;
import com.coway.trust.api.mobile.services.dtProductRetrun.DtProductRetrunJobForm;
import com.coway.trust.api.mobile.services.dtRc.DtRentalCollectionListDto;
import com.coway.trust.api.mobile.services.dtRc.DtRentalCollectionListForm;

/*********************************************************************************************
 * DATE PIC VERSION COMMENT
 * -----------------------------------------------------------------------------
 * 10/04/2019 ONGHC 1.0.1 - Add Logs
 * 08/05/2019 ONGHC 1.0.2 - Amend Logs
 * 08/05/2019 ONGHC 1.0.3 - Amend hsRegistration to add stage
 * 08/07/2019 ONGHC 1.0.4 - Amend asRegistration to fix Commission issue
 * 26/07/2019 ONGHC 1.0.5 - Amend asRegistration to fix Commission and Update User issue
 * 29/07/2019 ONGHC 1.0.6 - Amend productReturnResult to Add Status Checking
 * 30/07/2019 ONGHC 1.0.7 - Amend asRegistration
 * 18/10/2019 ONGHC 1.0.8 - Amend Installation for Product Exchange
 * 30/10/2019 ONGHC 1.0.9 - Amend Installation for add EXC_CT_ID as parameter
 * 22/04/2019 ONGHC 1.0.10 - Add function getRelateOrderInfo
 * 23/04/2019 ONGHC 1.0.11 - Add function getOrdDetail
 * 24/09/2020 FARUQ  1.0.12 - Missing product name when fail (mobile site only)
 * 07/07/2022 FARUQ  1.0.13 - establish /mobile/api/v1/service/insertAsFromCodyRequest
 * 03/04/2022 FANNIE 1.0.14 - Add function update GPS
 * 02/10/2023 ONGHC 1.0.15 - Remove Heavy Load Logger
 *********************************************************************************************
 * 04/03/2025 ONGHC 2.0.1   - File Restructure
 *********************************************************************************************/

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

  // @Autowired
  // private MessageSourceAccessor messageAccessor;

  @Resource(name = "servicesLogisticsPFCService")
  private ServicesLogisticsPFCService servicesLogisticsPFCService;

  // @Autowired
  // private AdaptorService adaptorService;

   @Resource(name = "HomecareServiceApiService")
   private HomecareServiceApiService homecareServiceApiService;

  @Resource(name = "returnUsedPartsService")
  private ReturnUsedPartsService returnUsedPartsService;

  @Resource(name = "serviceApiInstallationService")
  private ServiceApiInstallationService serviceApiInstallationService;

  @Resource(name = "serviceApiHSService")
  private ServiceApiHSService serviceApiHSService;

  @Resource(name = "serviceApiASService")
  private ServiceApiASService serviceApiASService;

  @Resource(name = "serviceApiPRService")
  private ServiceApiPRService serviceApiPRService;

  @Resource(name = "ihrApiService")
  private IhrApiService ihrApiService;

  @Resource(name = "asFromCodyApiService")
  private AsFromCodyApiService asFromCodyApiService;

  @Resource(name = "serviceMileageApiService")
  private ServiceMileageApiService serviceMileageApiService;

  /* MOBILE HOME APPLIANCE */
  /* HA HEART SERVICE  - START */
  @SuppressWarnings("static-access")
  @ApiOperation(value = "Heart Service Job List Search", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/heartServiceJobList", method = RequestMethod.GET)
  public ResponseEntity<List<HeartServiceJobDto>> getHeartServiceJob(@ModelAttribute HeartServiceJobForm HeartServiceJobForm) throws Exception {

    Map<String, Object> params = HeartServiceJobForm.createMap(HeartServiceJobForm);

    List<EgovMap> HeartServiceJobList = MSvcLogApiService.getHeartServiceJobList(params);

    List<HeartServiceJobDto> list = HeartServiceJobList.stream().map(r -> HeartServiceJobDto.create(r)).collect(Collectors.toList());

    return ResponseEntity.ok(list);
  }

  @SuppressWarnings("static-access")
  @ApiOperation(value = "Heart Service Job List batch Search", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/heartServiceJobList_b", method = RequestMethod.GET)
  public ResponseEntity<List<HeartServiceJobDto>> getHeartServiceJob_b(@ModelAttribute HeartServiceJobForm HeartServiceJobForm) throws Exception {

    Map<String, Object> params = HeartServiceJobForm.createMap(HeartServiceJobForm);

    List<EgovMap> HeartServiceJobList = MSvcLogApiService.getHeartServiceJobList_b(params);

    List<HeartServiceJobDto> list = HeartServiceJobList.stream().map(r -> HeartServiceJobDto.create(r)).collect(Collectors.toList());

    return ResponseEntity.ok(list);
  }

  @ApiOperation(value = "Heart Service Parts List Search", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/heartServiceParts", method = RequestMethod.GET)
  public ResponseEntity<List<HeartServicePartsDto>> heartServiceParts(@ModelAttribute HeartServicePartsForm heartServicePartsForm) throws Exception {

    Map<String, Object> params = HeartServicePartsForm.createMap(heartServicePartsForm);

    List<EgovMap> HeartServiceParts = MSvcLogApiService.heartServiceParts(params);

    List<HeartServicePartsDto> list = HeartServiceParts.stream().map(r -> HeartServicePartsDto.create(r)).collect(Collectors.toList());

    return ResponseEntity.ok(list);
  }

  @ApiOperation(value = "Heart Service Parts List batch Search", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/heartServiceParts_b", method = RequestMethod.GET)
  public ResponseEntity<List<HeartServicePartsDto>> heartServiceParts_b(@ModelAttribute HeartServicePartsForm heartServicePartsForm) throws Exception {

    Map<String, Object> params = HeartServicePartsForm.createMap(heartServicePartsForm);

    List<EgovMap> HeartServiceParts = MSvcLogApiService.heartServiceParts_b(params);

    List<HeartServicePartsDto> list = HeartServiceParts.stream().map(r -> HeartServicePartsDto.create(r)).collect(Collectors.toList());

    return ResponseEntity.ok(list);
  }

  @ApiOperation(value = "Heart Service Result Registration", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/heartServiceResult", method = RequestMethod.POST)
  public ResponseEntity<HeartServiceResultDto> hsRegistration(@RequestBody List<HeartServiceResultForm> heartForms) throws Exception {
    return serviceApiHSService.hsResult(heartForms);
  }

  @ApiOperation(value = "Heart Service Re-Appointment Request", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/hSReAppointmtRequest", method = RequestMethod.POST)
  public ResponseEntity<HSReAppointmtRequestDto> hSReAppointmtRequest(@RequestBody HSReAppointmtRequestForm hSReAppointmtRequestForm) throws Exception {
    String transactionId = "";

    Map<String, Object> params = HSReAppointmtRequestForm.createMaps(hSReAppointmtRequestForm);

    if (RegistrationConstants.IS_INSERT_HSRE_LOG) {
      MSvcLogApiService.saveHsReServiceLogs(params);
    }

    MSvcLogApiService.updateHsReAppointmentReturnResult(params);
    return ResponseEntity.ok(HSReAppointmtRequestDto.create(transactionId));
  }

  @ApiOperation(value = "Heart Service Fail Job Request", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/hSFailJobRequest", method = RequestMethod.POST)
  public ResponseEntity<HSFailJobRequestDto> hSFailJobRequest(@RequestBody HSFailJobRequestForm hSFailJobRequestForm) throws Exception {
    return serviceApiHSService.hsFailJobRequest(hSFailJobRequestForm);
  }

  /* HA HEART SERVICE - END */

  /* HA AFTER SERVICE - START */
  @SuppressWarnings("static-access")
  @ApiOperation(value = "AfterServiceJob List Search", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/afterServiceJobList", method = RequestMethod.GET)
  public ResponseEntity<List<AfterServiceJobDto>> getHeartServiceJob(@ModelAttribute AfterServiceJobForm AfterServiceJobForm) throws Exception {

    Map<String, Object> params = AfterServiceJobForm.createMap(AfterServiceJobForm);

    List<EgovMap> AfterServiceJobList = MSvcLogApiService.getAfterServiceJobList(params);

    List<AfterServiceJobDto> list = AfterServiceJobList.stream().map(r -> AfterServiceJobDto.create(r)).collect(Collectors.toList());

    return ResponseEntity.ok(list);
  }

  @SuppressWarnings("static-access")
  @ApiOperation(value = "AfterServiceJob List batch Search", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/afterServiceJobList_b", method = RequestMethod.GET)
  public ResponseEntity<List<AfterServiceJobDto_b>> getHeartServiceJob_b(@ModelAttribute AfterServiceJobForm AfterServiceJobForm) throws Exception {

    Map<String, Object> params = AfterServiceJobForm.createMap(AfterServiceJobForm);

    List<EgovMap> AfterServiceJobList = MSvcLogApiService.getAfterServiceJobList_b(params);

    List<AfterServiceJobDto_b> list = AfterServiceJobList.stream().map(r -> AfterServiceJobDto_b.create(r)).collect(Collectors.toList());

    return ResponseEntity.ok(list);
  }

  @ApiOperation(value = "After Service Parts List Search", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/afterServiceParts", method = RequestMethod.GET)
  public ResponseEntity<List<AfterServicePartsDto>> afterServiceParts(@ModelAttribute AfterServicePartsForm afterServicePartsForm) throws Exception {

    Map<String, Object> params = AfterServicePartsForm.createMap(afterServicePartsForm);

    List<EgovMap> AfterServiceParts = MSvcLogApiService.afterServiceParts(params);

    List<AfterServicePartsDto> list = AfterServiceParts.stream().map(r -> AfterServicePartsDto.create(r)).collect(Collectors.toList());

    return ResponseEntity.ok(list);
  }

  @ApiOperation(value = "After Service Parts List batch Search", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/afterServiceParts_b", method = RequestMethod.GET)
  public ResponseEntity<List<AfterServicePartsDto>> afterServiceParts_b(@ModelAttribute AfterServicePartsForm afterServicePartsForm) throws Exception {

    Map<String, Object> params = AfterServicePartsForm.createMap(afterServicePartsForm);

    List<EgovMap> AfterServiceParts = MSvcLogApiService.afterServiceParts_b(params);

    List<AfterServicePartsDto> list = AfterServiceParts.stream().map(r -> AfterServicePartsDto.create(r)).collect(Collectors.toList());

    return ResponseEntity.ok(list);
  }

  @ApiOperation(value = "After Service Result Registration", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/afterServiceResult", method = RequestMethod.POST)
  public ResponseEntity<AfterServiceResultDto> asRegistration(@RequestBody List<AfterServiceResultForm> afterServiceForms) throws Exception {
    return serviceApiASService.asResult(afterServiceForms);
  }

  @ApiOperation(value = "After Service Re-Appointment Request", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/aSReAppointmentRequest", method = RequestMethod.POST)
  public ResponseEntity<ASReAppointmentRequestDto> aSReAppointmentRequest(@RequestBody ASReAppointmentRequestForm aSReAppointmentRequestForm) throws Exception {
    String transactionId = "";
    SimpleDateFormat transFormat = new SimpleDateFormat("yyyyMMdd");
    // SimpleDateFormat transFormat1 = new SimpleDateFormat("yyyy-MM-dd");
    DateFormat sdFormat = new SimpleDateFormat("ddMMyyyy");
    // DateFormat sdFormat1 = new SimpleDateFormat("dd-MM-yyyy");

    DateFormat timeFormatOrg = new SimpleDateFormat("HHmm");
    DateFormat timeFormatNew = new SimpleDateFormat("HH:mm:ss.SSS");

    Map<String, Object> params = ASReAppointmentRequestForm.createMaps(aSReAppointmentRequestForm);

    if (RegistrationConstants.IS_INSERT_ASRE_LOG) {
      MSvcLogApiService.saveAsReServiceLogs(params);
    }

    // String userId = MSvcLogApiService.getUseridToMemid(params);
    Date appointmentTime = timeFormatOrg.parse((String) params.get("appointmentTime"));
    String appointmentTime1 = timeFormatNew.format(appointmentTime);

    String appTime = String.valueOf(params.get("appointmentTime"));
    int hour = Integer.parseInt(appTime.substring(0, 2));

    if (hour >= 00 && hour <= 10) {
      params.put("sesionCode", "M");
    } else if (hour >= 10 && hour <= 14) {
      params.put("sesionCode", "A");
    } else if (hour >= 14 && hour <= 19) {
      params.put("sesionCode", "E");
    } else {
      params.put("sesionCode", "E");
    }

    params.put("AS_APPNT_DT", sdFormat.format(transFormat.parse((String) params.get("appointmentDate"))));
    params.put("AS_APPNT_TM", String.valueOf(appointmentTime1));
    params.put("AS_SESION_CODE", params.get("sesionCode"));
    params.put("AS_NO", params.get("serviceNo"));
    params.put("AS_UPD_USER_ID", params.get("userId"));

    // ASManagementListService.updateASEntry(params);

    MSvcLogApiService.updateReApointResult(params);
    return ResponseEntity.ok(ASReAppointmentRequestDto.create(transactionId));
  }

  @ApiOperation(value = "After Service Fail Job Request", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/aSFailJobRequest", method = RequestMethod.POST)
  public ResponseEntity<ASFailJobRequestDto> aSFailJobRequest(@RequestBody ASFailJobRequestForm aSFailJobRequestForm) throws Exception {
    return serviceApiASService.asFailJobRequest(aSFailJobRequestForm);
  }

  @ApiOperation(value = "AS Request Result List", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/aSRequestResultList", method = RequestMethod.POST)
  public ResponseEntity<List<ASRequestResultDto>> aSRequestResultList(@RequestBody ASRequestResultForm aSRequestResultForm) throws Exception {
    Map<String, Object> map = new HashMap<String, Object>();

    map.put("userId", (String) aSRequestResultForm.getUserId());
    map.put("searchFromDate", (String) aSRequestResultForm.getSearchFromDate());
    map.put("searchToDate", (String) aSRequestResultForm.getSearchToDate());

    List<EgovMap> rcList = MSvcLogApiService.getASRequestResultList(map);

    List<ASRequestResultDto> list = rcList.stream().map(r -> ASRequestResultDto.create(r)).collect(Collectors.toList());

    return ResponseEntity.ok(list);
  }

  @ApiOperation(value = "AS Request Customer Search", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/aSRequestCust", method = RequestMethod.POST)
  public ResponseEntity<List<ASRequestCustDto>> aSRequestCust(@RequestBody ASRequestCustForm aSRequestCustForm) throws Exception {
    Map<String, Object> map = new HashMap<String, Object>();

    map.put("userId", (String) aSRequestCustForm.getUserId());
    map.put("searchType", (String) aSRequestCustForm.getSearchType());
    map.put("searchKeyword", (String) aSRequestCustForm.getSearchKeyword());

    List<EgovMap> rcList = MSvcLogApiService.getASRequestCustList(map);

    List<ASRequestCustDto> list = rcList.stream().map(r -> ASRequestCustDto.create(r)).collect(Collectors.toList());

    return ResponseEntity.ok(list);
  }

  @ApiOperation(value = "AS Request Registration", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/aSRequestRegistration", method = RequestMethod.POST)
  public ResponseEntity<ASRequestRegistDto> aSRequestRegistration(@RequestBody ASRequestRegistForm aSRequestRegistForm) throws Exception {

    String transactionId = "";
    Map<String, Object> params = ASRequestRegistForm.createMaps(aSRequestRegistForm);


    if (RegistrationConstants.IS_INSERT_ASRE_LOG) {
      MSvcLogApiService.saveASRequestRegistrationLogs(params);
    }

    MSvcLogApiService.insertASRequestRegist(params);

    return ResponseEntity.ok(ASRequestRegistDto.create(transactionId));
  }

  /* HA AFTER SERVICE - END */

  /* HA INSTALLATION - START */
  @SuppressWarnings("static-access")
  @ApiOperation(value = "InstallationJob List Search", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/installationJobList", method = RequestMethod.GET)
  public ResponseEntity<List<InstallationJobDto>> getInstallationJobList(@ModelAttribute InstallationJobForm InstallationJobForm) throws Exception {
    Map<String, Object> params = InstallationJobForm.createMap(InstallationJobForm);

    List<EgovMap> InstallationJobList = MSvcLogApiService.getInstallationJobList(params);

    List<InstallationJobDto> list = InstallationJobList.stream().map(r -> InstallationJobDto.create(r)).collect(Collectors.toList());

    return ResponseEntity.ok(list);
  }

  @SuppressWarnings("static-access")
  @ApiOperation(value = "InstallationJob List batchSearch", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/installationJobList_b", method = RequestMethod.GET)
  public ResponseEntity<List<InstallationJobDto>> getInstallationJobList_b(@ModelAttribute InstallationJobForm InstallationJobForm) throws Exception {

    Map<String, Object> params = InstallationJobForm.createMap(InstallationJobForm);

    List<EgovMap> InstallationJobList = MSvcLogApiService.getInstallationJobList_b(params);

    List<InstallationJobDto> list = InstallationJobList.stream().map(r -> InstallationJobDto.create(r)).collect(Collectors.toList());

    return ResponseEntity.ok(list);
  }

  @ApiOperation(value = "Installation Result Registration", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/installationResult", method = RequestMethod.POST)
  public ResponseEntity<InstallationResultDto> installationResult(@RequestBody List<InstallationResultForm> installationResultForms) throws Exception {
    return serviceApiInstallationService.installationResult(installationResultForms);
  }

  @ApiOperation(value = "Installation Re-Appointment Request", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/installReAppointmentRequest", method = RequestMethod.POST)
  public ResponseEntity<InstallReAppointmentRequestDto> installReAppointmentRequest(@RequestBody InstallReAppointmentRequestForm installReAppointmentRequestForm) throws Exception {
    String transactionId = "";

    Map<String, Object> params = InstallReAppointmentRequestForm.createMaps(installReAppointmentRequestForm);

    if (RegistrationConstants.IS_INSERT_INSRE_LOG) {
      MSvcLogApiService.saveInsReServiceLogs(params);
    }

    String appTime = String.valueOf(params.get("appointmentTime"));
    int hour = Integer.parseInt(appTime.substring(0, 2));

    if (hour >= 00 && hour <= 10) {
      params.put("sesionCode", "M");
    } else if (hour >= 10 && hour <= 14) {
      params.put("sesionCode", "A");
    } else if (hour >= 14 && hour <= 19) {
      params.put("sesionCode", "E");
    } else {
      params.put("sesionCode", "O");
    }

    MSvcLogApiService.updateInsReAppointmentReturnResult(params);

    return ResponseEntity.ok(InstallReAppointmentRequestDto.create(transactionId));
  }

  @ApiOperation(value = "Installation Fail Job Request", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/installFailJobRequest", method = RequestMethod.POST)
  public ResponseEntity<InstallFailJobRequestDto> installFailJobRequest(@RequestBody InstallFailJobRequestForm installFailJobRequestForm) throws Exception {
    return serviceApiInstallationService.installFailJobRequest(installFailJobRequestForm);
  }

  /* HA INSTALLATION - END */

  /* HA PRODUCT RETURN - START */
  @SuppressWarnings("static-access")
  @ApiOperation(value = "ProductReturnJob List Search", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/productRetrunJobList", method = RequestMethod.GET)
  public ResponseEntity<List<ProductRetrunJobDto>> getProductRetrunJobList(@ModelAttribute ProductRetrunJobForm ProductRetrunJobForm) throws Exception {
    Map<String, Object> params = ProductRetrunJobForm.createMap(ProductRetrunJobForm);

    List<EgovMap> ProductRetrunJobList = MSvcLogApiService.getProductRetrunJobList(params);

    List<ProductRetrunJobDto> list = ProductRetrunJobList.stream().map(r -> ProductRetrunJobDto.create(r)).collect(Collectors.toList());

    return ResponseEntity.ok(list);
  }

  @SuppressWarnings("static-access")
  @ApiOperation(value = "ProductReturnJob List batch Search", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/productRetrunJobList_b", method = RequestMethod.GET)
  public ResponseEntity<List<ProductRetrunJobDto>> getProductRetrunJobList_b(@ModelAttribute ProductRetrunJobForm ProductRetrunJobForm) throws Exception {

    Map<String, Object> params = ProductRetrunJobForm.createMap(ProductRetrunJobForm);

    List<EgovMap> ProductRetrunJobList = MSvcLogApiService.getProductRetrunJobList_b(params);

    List<ProductRetrunJobDto> list = ProductRetrunJobList.stream().map(r -> ProductRetrunJobDto.create(r)).collect(Collectors.toList());

    return ResponseEntity.ok(list);
  }

  @ApiOperation(value = "Product Return Result Registration", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/productReturnResult", method = RequestMethod.POST)
  public ResponseEntity<ProductReturnResultDto> productReturnResult(@RequestBody List<ProductReturnResultForm> productReturnResultForm) throws Exception {
    return serviceApiPRService.productReturnResult(productReturnResultForm);
  }

  @ApiOperation(value = "Product Return Re-Appointment Request", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/pRReAppointmentRequest", method = RequestMethod.POST)
  public ResponseEntity<PRReAppointmentRequestDto> pRReAppointmentRequest(@RequestBody PRReAppointmentRequestForm pRReAppointmentRequestForm) throws Exception {
    String transactionId = "";

    Map<String, Object> params = PRReAppointmentRequestForm.createMaps(pRReAppointmentRequestForm);

    if (RegistrationConstants.IS_INSERT_PRRE_LOG) {
      MSvcLogApiService.savePrReServiceLogs(params);
    }

    MSvcLogApiService.updatePrReAppointmentReturnResult(params);

    transactionId = pRReAppointmentRequestForm.getTransactionId();
    return ResponseEntity.ok(PRReAppointmentRequestDto.create(transactionId));
  }

  @ApiOperation(value = "Product Return Fail Job Request", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/pRFailJobRequest", method = RequestMethod.POST)
  public ResponseEntity<PRFailJobRequestDto> pRReAppointmentRequest(@RequestBody PRFailJobRequestForm pRFailJobRequestForm) throws Exception {
    return serviceApiPRService.prReAppointmentRequest(pRFailJobRequestForm);
  }

  /* HA PRODUCT RETURN - END */

  /* HOMECARE */
  /* HC HEART SERVICE - START */
  @ApiOperation(value = "HomeCare Heart Service Job List Search", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/careServiceJobList", method = RequestMethod.GET)
  public ResponseEntity<List<CareServiceJobDto>> getCareServiceJob(@ModelAttribute CareServiceJobForm careServiceJobForm) throws Exception {
    Map<String, Object> params = CareServiceJobForm.createMap(careServiceJobForm);

    List<EgovMap> careServiceJobList = MSvcLogApiService.getCareServiceJobList(params);

    List<CareServiceJobDto> list = careServiceJobList.stream().map(r -> CareServiceJobDto.create(r)).collect(Collectors.toList());

    return ResponseEntity.ok(list);
  }

  @ApiOperation(value = "HomeCare Heart Service Job List Search", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/hcServiceJobList", method = RequestMethod.GET)
  public ResponseEntity<List<HcServiceJobDto>> getHcServiceJob(@ModelAttribute HcServiceJobForm hcServiceJobForm) throws Exception {
    Map<String, Object> params = HcServiceJobForm.createMap(hcServiceJobForm);

    List<EgovMap> hcServiceJobList = MSvcLogApiService.getHcServiceJobList(params);

    List<HcServiceJobDto> list = hcServiceJobList.stream().map(r -> HcServiceJobDto.create(r)).collect(Collectors.toList());

    return ResponseEntity.ok(list);
  }

  @ApiOperation(value = "HomeCare Heart Service Parts List Search", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/careServiceParts", method = RequestMethod.GET)
  public ResponseEntity<List<CareServicePartsDto>> getCareServiceParts(@ModelAttribute CareServicePartsForm careServicePartsForm) throws Exception {
    Map<String, Object> params = CareServicePartsForm.createMap(careServicePartsForm);

    List<EgovMap> careServiceParts = MSvcLogApiService.heartServiceParts(params);

    List<CareServicePartsDto> list = careServiceParts.stream().map(r -> CareServicePartsDto.create(r)).collect(Collectors.toList());

    return ResponseEntity.ok(list);
  }

  @ApiOperation(value = "Homecare Heart Service Re-Appointment Request", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/hTReAppointmtRequest", method = RequestMethod.POST)
  public ResponseEntity<HSReAppointmtRequestDto> hTReAppointmtRequest(@RequestBody HSReAppointmtRequestForm hSReAppointmtRequestForm) throws Exception {
    String transactionId = "";

    Map<String, Object> params = HSReAppointmtRequestForm.createMaps(hSReAppointmtRequestForm);

    MSvcLogApiService.updateHTReAppointmentReturnResult(params);

    return ResponseEntity.ok(HSReAppointmtRequestDto.create(transactionId));
  }

  @ApiOperation(value = "Homecare Heart Service Fail Job Request", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/htFailJobRequest", method = RequestMethod.POST)
  public ResponseEntity<HSFailJobRequestDto> htFailJobRequest(@RequestBody HSFailJobRequestForm hSFailJobRequestForm) throws Exception {
    return serviceApiHSService.htFailJobRequest(hSFailJobRequestForm);
  }

  @ApiOperation(value = "Homecare Heart Service Result Registration", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/careServiceResult", method = RequestMethod.POST)
  public ResponseEntity<HeartServiceResultDto> careServiceResult(@RequestBody List<HeartServiceResultForm> heartForms) throws Exception {
    return serviceApiHSService.htResult(heartForms);
  }

  @SuppressWarnings("unchecked")
  @ApiOperation(value = "HomeCare Service History List", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/hcServiceHistory", method = RequestMethod.POST)
  public ResponseEntity<List<ServiceHistoryDto>> hcServiceHistory(@RequestBody ServiceHistoryForm serviceHistoryForm) throws Exception {
    Map<String, Object> params = ServiceHistoryForm.createMaps(serviceHistoryForm);

    List<EgovMap> headerList = MSvcLogApiService.hcServiceHistory(params);

    List<ServiceHistoryDto> hList = new ArrayList<>();
    for (int i = 0; i < headerList.size(); i++) {
      LOGGER.debug("# SERVICE HISTORY LIST : " + headerList.get(i).toString());
    }

    for (int i = 0; i < headerList.size(); i++) {
      hList = headerList.stream().map(r -> ServiceHistoryDto.create(r)).collect(Collectors.toList());

      for (int j = 0; j < hList.size(); j++) {
        Map<String, Object> tmpMap = headerList.get(j);

        LOGGER.debug("# REQUEST STATUS HEADER 1 : ", tmpMap.get("jobType"));

        if ("AS".equals(tmpMap.get("jobType").toString())) {
          List<EgovMap> historyParts = MSvcLogApiService.getAsPartsHistoryDList(tmpMap);

          List<ServiceHistoryPartDetailDto> partsList = historyParts.stream().map(r -> ServiceHistoryPartDetailDto.create(r)).collect(Collectors.toList());
          hList.get(j).setPartList(partsList);
        } else {
          tmpMap.put("bsResultId", tmpMap.get("asResultId"));
          List<EgovMap> historyParts = MSvcLogApiService.getHsPartsHistoryDList(tmpMap);

          List<ServiceHistoryPartDetailDto> partsList = historyParts.stream().map(r -> ServiceHistoryPartDetailDto.create(r)).collect(Collectors.toList());
          hList.get(j).setPartList(partsList);
        }
      }

      for (int k = 0; k < hList.size(); k++) {
        Map<String, Object> tmpMap1 = headerList.get(k);

        LOGGER.debug("# REQUEST STATUS HEADER 2 : " + tmpMap1.get("jobType").toString());

        if ("AS".equals(tmpMap1.get("jobType").toString())) {
          List<EgovMap> historyFilters = MSvcLogApiService.getAsFilterHistoryDList(tmpMap1);

          List<ServiceHistoryFilterDetailDto> filterList = historyFilters.stream().map(r -> ServiceHistoryFilterDetailDto.create(r)).collect(Collectors.toList());
          hList.get(k).setFilterList(filterList);
        } else {
          tmpMap1.put("bsResultId", tmpMap1.get("asResultId"));
          List<EgovMap> historyFilters = MSvcLogApiService.getHsFilterHistoryDList(tmpMap1);

          List<ServiceHistoryFilterDetailDto> filterList = historyFilters.stream().map(r -> ServiceHistoryFilterDetailDto.create(r)).collect(Collectors.toList());
          hList.get(k).setFilterList(filterList);
        }
      }
    }

    return ResponseEntity.ok(hList);
  }

  /* HC HEART SERVICE - END */

  /* HC AFTER SERVICE - START */
  @ApiOperation(value = "Homecare After Service Job List Search", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/dtAfterServiceJobList", method = RequestMethod.GET)
  public ResponseEntity<List<DtAfterServiceJobDto>> getDtAfterServiceJobList(@ModelAttribute DtAfterServiceJobForm dtAfterServiceJobForm) throws Exception {
    Map<String, Object> params = DtAfterServiceJobForm.createMap(dtAfterServiceJobForm);

    List<EgovMap> dtAfterServiceJobList = MSvcLogApiService.getAfterServiceJobList(params);

    List<DtAfterServiceJobDto> list = dtAfterServiceJobList.stream().map(r -> DtAfterServiceJobDto.create(r)).collect(Collectors.toList());

    return ResponseEntity.ok(list);
  }

  @ApiOperation(value = "Homecare After Service Parts List Search", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/dtAfterServiceParts", method = RequestMethod.GET)
  public ResponseEntity<List<DtAfterServicePartsDto>> getDtAfterServiceParts(@ModelAttribute DtAfterServicePartsForm dtAfterServicePartsForm) throws Exception {
    Map<String, Object> params = DtAfterServicePartsForm.createMap(dtAfterServicePartsForm);

    List<EgovMap> dtAfterServiceParts = MSvcLogApiService.afterServiceParts(params);

    List<DtAfterServicePartsDto> list = dtAfterServiceParts.stream().map(r -> DtAfterServicePartsDto.create(r)).collect(Collectors.toList());

    return ResponseEntity.ok(list);
  }

  @ApiOperation(value = "Homecare After Service Fail Job Request", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/dtAsFailJobRequest", method = RequestMethod.POST)
  public ResponseEntity<ASFailJobRequestDto> dtAsFailJobRequest(@RequestBody ASFailJobRequestForm aSFailJobRequestForm) throws Exception {
    return serviceApiASService.asFailJobRequest(aSFailJobRequestForm);
  }

  @ApiOperation(value = "Homecare After Service Result Registration", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/dtAfterServiceResult", method = RequestMethod.POST)
  public ResponseEntity<AfterServiceResultDto> dtAfterServiceResult(@RequestBody List<AfterServiceResultForm> afterServiceForms) throws Exception {
    return serviceApiASService.asDtResult(afterServiceForms);
  }

  /* HC AFTER SERVICE - END */

  /* HC INSTALLATION - START */
  @ApiOperation(value = "Homecare Installation Job List Search", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/dtInstallationJobList", method = RequestMethod.GET)
  public ResponseEntity<List<DtInstallationJobDto>> getDtInstallationJobList(@ModelAttribute DtInstallationJobForm dtInstallationJobForm) throws Exception {
    Map<String, Object> params = DtInstallationJobForm.createMap(dtInstallationJobForm);

    List<EgovMap> dtInstallationJobList = MSvcLogApiService.getDtInstallationJobList(params);

    List<DtInstallationJobDto> list = dtInstallationJobList.stream().map(r -> DtInstallationJobDto.create(r)).collect(Collectors.toList());

    return ResponseEntity.ok(list);
  }

  @ApiOperation(value = "Homecare Installation DT Re-Appointment Request", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/installDtReAppointmentRequest", method = RequestMethod.POST)
  public ResponseEntity<InstallReAppointmentRequestDto> installDtReAppointmentRequest(@RequestBody InstallReAppointmentRequestForm installReAppointmentRequestForm) throws Exception {
    String transactionId = "";

    Map<String, Object> params = InstallReAppointmentRequestForm.createMaps(installReAppointmentRequestForm);

    if (RegistrationConstants.IS_INSERT_INSRE_LOG) {
      MSvcLogApiService.saveInsReServiceLogs(params);
    }

    String appTime = String.valueOf(params.get("appointmentTime"));
    int hour = Integer.parseInt(appTime.substring(0, 2));

    if (hour >= 00 && hour <= 10) {
      params.put("sesionCode", "M");
    } else if (hour >= 10 && hour <= 14) {
      params.put("sesionCode", "A");
    } else if (hour >= 14 && hour <= 19) {
      params.put("sesionCode", "E");
    } else {
      params.put("sesionCode", "O");
    }

    MSvcLogApiService.updateInsDtReAppointmentReturnResult(params);

    return ResponseEntity.ok(InstallReAppointmentRequestDto.create(transactionId));
  }

  @ApiOperation(value = "Homecare Installation Fail Job Request", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/dtInstallFailJobRequest", method = RequestMethod.POST)
  public ResponseEntity<InstallFailJobRequestDto> dtInstallFailJobRequest(@RequestBody InstallFailJobRequestForm installFailJobRequestForm) throws Exception {
    return serviceApiInstallationService.installDtFailJobRequest(installFailJobRequestForm);
  }

  @ApiOperation(value = "Homecare Installation Result Registration", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/dtInstallationResult", method = RequestMethod.POST)
  public ResponseEntity<InstallationResultDto> dtInstallationResult(@RequestBody List<InstallationResultForm> installationResultForms) throws Exception {
    return serviceApiInstallationService.installationDtResult(installationResultForms);
  }

  /* HC INSTALLATION - END */

  /* HC PRODUCT RETURN - START */
  @ApiOperation(value = "Homecare Product Return Job List Search", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/dtProductRetrunJobList", method = RequestMethod.GET)
  public ResponseEntity<List<DtProductRetrunJobDto>> getDtProductRetrunJobList(@ModelAttribute DtProductRetrunJobForm dtProductRetrunJobForm) throws Exception {
    Map<String, Object> params = DtProductRetrunJobForm.createMap(dtProductRetrunJobForm);

    List<EgovMap> dtProductRetrunJobList = MSvcLogApiService.getProductRetrunJobList(params);

    List<DtProductRetrunJobDto> list = dtProductRetrunJobList.stream().map(r -> DtProductRetrunJobDto.create(r)).collect(Collectors.toList());

    return ResponseEntity.ok(list);
  }

  @ApiOperation(value = "Homecare Product Return Fail Job Request", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/dtPRFailJobRequest", method = RequestMethod.POST)
  public ResponseEntity<PRFailJobRequestDto> dtPRFailJobRequest(@RequestBody PRFailJobRequestForm pRFailJobRequestForm) throws Exception {
    return serviceApiPRService.prReAppointmentDtRequest(pRFailJobRequestForm);
  }

  @ApiOperation(value = "Homecare Product Return Result Registration", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/dtProductReturnResult", method = RequestMethod.POST)
  public ResponseEntity<ProductReturnResultDto> dtProductReturnResult(@RequestBody List<ProductReturnResultForm> productReturnResultForm) throws Exception {
    return serviceApiPRService.productReturnDtResult(productReturnResultForm);
  }
  /* HC PRODUCT RETURN - END */

  /* OTHER - RC LISTING */
  @ApiOperation(value = "Display RC List", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/rcList", method = RequestMethod.POST)
  public ResponseEntity<List<RentalServiceCustomerDto>> rentalCustomerPaymentList(@RequestBody RentalServiceCustomerForm rentalForm) throws Exception {

    Map<String, Object> map = new HashMap<String, Object>();
    map.put("userId", String.valueOf(rentalForm.getUserId()));
    map.put("searchType", String.valueOf(rentalForm.getSearchType()));
    map.put("searchKeyword", String.valueOf(rentalForm.getSearchKeyword()));

    List<EgovMap> rcList = MSvcLogApiService.getRentalCustomerList(map);

    List<RentalServiceCustomerDto> list = null;

    if (rcList != null) {
      list = rcList.stream().map(r -> RentalServiceCustomerDto.create(r)).collect(Collectors.toList());
    }

    return ResponseEntity.ok(list);
  }

  @ApiOperation(value = "Cancel SMS Request", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/canSMSRequestRequest", method = RequestMethod.POST)
  public ResponseEntity<CanCelDto> canSMSRequestRequest(@RequestBody CanCelSmsForm canCelSmsForm) throws Exception {
    String transactionId = "";
    SessionVO session = new SessionVO();

    Map<String, Object> params = CanCelSmsForm.createMap(canCelSmsForm);

    // List<String> mobileNumList = new ArrayList<String>();

    if (RegistrationConstants.IS_INSERT_PRFAIL_LOG) {
      MSvcLogApiService.saveCanSMSServiceLogs(params);
    }

    String cancReqNo = "";
    cancReqNo = MSvcLogApiService.getcancReqNo(params);
    params.put("cancReqNo", cancReqNo);

    MSvcLogApiService.insertCancelSMS(params);

    SmsVO sms = new SmsVO(session.getUserId(), 975);

    String smsString = ("Do you really want to cancel for the current month Heart Service? " + "\n" + " HS Order Number :" + params.get("serviceNo") + "\n" + " Cancel Request Number :" + cancReqNo);

    sms.setMessage(smsString);
    sms.setMobiles((String) canCelSmsForm.getReceiverTelNo());

    // SmsResult smsResult = adaptorService.sendSMS(sms);

    return ResponseEntity.ok(CanCelDto.create(transactionId));
  }

  @ApiOperation(value = "selectSyncIhr", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/selectSyncIhr", method = RequestMethod.GET)
  public ResponseEntity<List<SyncIhrApiDto>> selectSyncIhr(@ModelAttribute SyncIhrApiForm param) throws Exception {
    List<EgovMap> selectSyncIhr = ihrApiService.selectSyncIhr(param);

    if (LOGGER.isErrorEnabled()) {
      for (int i = 0; i < selectSyncIhr.size(); i++) {
        LOGGER.debug("selectSyncIhr    값 : {}", selectSyncIhr.get(i));
      }
    }

    return ResponseEntity.ok(selectSyncIhr.stream().map(r -> SyncIhrApiDto.create(r)).collect(Collectors.toList()));
  }

  @ApiOperation(value = "selectPartnerCode", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/selectPartnerCode", method = RequestMethod.GET)
  public ResponseEntity<List<HomecareServiceApiDto>> selectPartnerCode(@ModelAttribute HomecareServiceApiForm param) throws Exception {
      List<EgovMap>  selectPartnerCode = homecareServiceApiService.selectPartnerCode(param);
      if(LOGGER.isErrorEnabled()){
          for (int i = 0; i < selectPartnerCode.size(); i++) {
            LOGGER.debug("PAIRING PARTNER CODE : {}", selectPartnerCode.get(i));
          }
      }
      return ResponseEntity.ok(selectPartnerCode.stream().map(r -> HomecareServiceApiDto.create(r)).collect(Collectors.toList()));
  }

  @ApiOperation(value = "selectAsPartnerCode", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/selectAsPartnerCode", method = RequestMethod.GET)
  public ResponseEntity<List<HomecareAfterServiceApiDto>> selectAsPartnerCode(@ModelAttribute HomecareAfterServiceApiForm param) throws Exception {
      List<EgovMap>  selectAsPartnerCode = homecareServiceApiService.selectAsPartnerCode(param);
      if(LOGGER.isErrorEnabled()){
          for (int i = 0; i < selectAsPartnerCode.size(); i++) {
                  LOGGER.debug("selectAsPartnerCode    값 : {}", selectAsPartnerCode.get(i));
          }
      }
      return ResponseEntity.ok(selectAsPartnerCode.stream().map(r -> HomecareAfterServiceApiDto.create(r)).collect(Collectors.toList()));
  }

  @ApiOperation(value = "selectAsDetails", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/selectAsDetails", method = RequestMethod.GET)
  public ResponseEntity<AsDetailDto> selectAsDetails(@ModelAttribute AsDetailForm param) throws Exception {
    return ResponseEntity.ok(MSvcLogApiService.selectAsDetails(param));
  }

  @SuppressWarnings("unchecked")
  @ApiOperation(value = "Service History List", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/serviceHistory", method = RequestMethod.POST)
  public ResponseEntity<List<ServiceHistoryDto>> serviceHistory(@RequestBody ServiceHistoryForm serviceHistoryForm) throws Exception {
    Map<String, Object> params = ServiceHistoryForm.createMaps(serviceHistoryForm);

    List<EgovMap> headerList = MSvcLogApiService.serviceHistory(params);

    List<ServiceHistoryDto> hList = new ArrayList<>();
    for (int i = 0; i < headerList.size(); i++) {
      LOGGER.debug("# SERVICE HISTORY LIST : " + headerList.get(i).toString());
    }

    for (int i = 0; i < headerList.size(); i++) {
      hList = headerList.stream().map(r -> ServiceHistoryDto.create(r)).collect(Collectors.toList());

      for (int j = 0; j < hList.size(); j++) {
        Map<String, Object> tmpMap = headerList.get(j);

        LOGGER.debug("# REQUEST STATUS HEADER 1 : ", tmpMap.get("jobType"));

        if ("AS".equals(tmpMap.get("jobType").toString())) {
          List<EgovMap> historyParts = MSvcLogApiService.getAsPartsHistoryDList(tmpMap);

          List<ServiceHistoryPartDetailDto> partsList = historyParts.stream().map(r -> ServiceHistoryPartDetailDto.create(r)).collect(Collectors.toList());
          hList.get(j).setPartList(partsList);
        } else {
          tmpMap.put("bsResultId", tmpMap.get("asResultId"));
          List<EgovMap> historyParts = MSvcLogApiService.getHsPartsHistoryDList(tmpMap);

          List<ServiceHistoryPartDetailDto> partsList = historyParts.stream().map(r -> ServiceHistoryPartDetailDto.create(r)).collect(Collectors.toList());
          hList.get(j).setPartList(partsList);
        }
      }

      for (int k = 0; k < hList.size(); k++) {
        Map<String, Object> tmpMap1 = headerList.get(k);

        LOGGER.debug("# REQUEST STATUS HEADER 2 : " + tmpMap1.get("jobType").toString());

        if ("AS".equals(tmpMap1.get("jobType").toString())) {
          List<EgovMap> historyFilters = MSvcLogApiService.getAsFilterHistoryDList(tmpMap1);

          List<ServiceHistoryFilterDetailDto> filterList = historyFilters.stream().map(r -> ServiceHistoryFilterDetailDto.create(r)).collect(Collectors.toList());
          hList.get(k).setFilterList(filterList);
        } else {
          tmpMap1.put("bsResultId", tmpMap1.get("asResultId"));
          List<EgovMap> historyFilters = MSvcLogApiService.getHsFilterHistoryDList(tmpMap1);

          List<ServiceHistoryFilterDetailDto> filterList = historyFilters.stream().map(r -> ServiceHistoryFilterDetailDto.create(r)).collect(Collectors.toList());
          hList.get(k).setFilterList(filterList);
        }
      }
    }
    return ResponseEntity.ok(hList);
  }

  @ApiOperation(value = "Outstanding Result", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/outstandingResult", method = RequestMethod.POST)
  public ResponseEntity<OutStandingResultVo> outStandingResult(@RequestBody RentalServiceCustomerForm rentalForm) throws Exception {
    Map<String, Object> map = new HashMap<String, Object>();

    map.put("userId", (String) rentalForm.getUserId());
    map.put("salesOrderNo", (String) rentalForm.getSalesOrderNo());

    OutStandingResultVo orv = new OutStandingResultVo();

    Map<String, Object> rmap = MSvcLogApiService.selectOutstandingResult(map);

    if (rmap != null) {
      LOGGER.debug(" rmap {}", rmap);
    }

    List<EgovMap> rcList = MSvcLogApiService.selectOutstandingResultDetailList(map);

    List<OutStandignResultDetail> list = rcList.stream().map(r -> OutStandignResultDetail.create(r)).collect(Collectors.toList());

    orv.setOsrd(list);

    if (rmap != null) {
      orv.setSumRpf(String.valueOf(rmap.get("sumRpf")));
      orv.setSumRpt(String.valueOf(rmap.get("sumRpt")));
      orv.setSumRhf(String.valueOf(rmap.get("sumRhf")));
      orv.setSumRental(String.valueOf(rmap.get("sumRental")));
      orv.setSumAdjust(String.valueOf(rmap.get("sumAdjust")));
    } else {
      orv.setSumRpf("0");
      orv.setSumRpt("0");
      orv.setSumRhf("0");
      orv.setSumRental("0");
      orv.setSumAdjust("0");
    }

    return ResponseEntity.ok(orv);

  }

  @ApiOperation(value = "Serial List Search", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/selectSerialList", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectSerialList(@RequestParam Map<String, Object> params) throws Exception {
    List<EgovMap> selectSerialList = MSvcLogApiService.selectSerialList(params);

    return ResponseEntity.ok(selectSerialList);
  }

  @SuppressWarnings({ "unchecked", "static-access" })
  @ApiOperation(value = "Related Order List", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/getRelateOrderInfo", method = RequestMethod.POST)
  public ResponseEntity<List<RelateOrderListDto>> getRelateOrderInfo(@RequestBody RelateOrderListForm RelateOrderListForm) throws Exception {
    Map<String, Object> params = RelateOrderListForm.createMaps(RelateOrderListForm);

    List<EgovMap> headerList = MSvcLogApiService.getRelateOrdLst(params);

    List<RelateOrderListDto> hList = new ArrayList<>();
    for (int i = 0; i < headerList.size(); i++) {
      LOGGER.debug("# RELATED ORDER LIST : " + headerList.get(i).toString());
    }

    for (int i = 0; i < headerList.size(); i++) {
      hList = headerList.stream().map(r -> RelateOrderListDto.create(r)).collect(Collectors.toList());

      for (int j = 0; j < hList.size(); j++) {
        Map<String, Object> tmpMap = headerList.get(j);

        List<EgovMap> ordDetail = MSvcLogApiService.getOrdDetail(tmpMap);

        List<SalesDetailDto> ordDetailList = ordDetail.stream().map(r -> SalesDetailDto.create(r)).collect(Collectors.toList());
        hList.get(j).setSalesDetail(ordDetailList);
      }
    }

    return ResponseEntity.ok(hList);
  }

  @SuppressWarnings("static-access")
  @ApiOperation(value = "Rental Collection List Search", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/searchRentalCollectionByBSNewList", method = RequestMethod.GET)
  public ResponseEntity<List<DtRentalCollectionListDto>> searchRentalCollectionByBSNewList(@ModelAttribute DtRentalCollectionListForm DtRentalCollectionListForm) throws Exception {

    Map<String, Object> params = DtRentalCollectionListForm.createMap(DtRentalCollectionListForm);

    List<EgovMap> DtRentalCollectionList = MSvcLogApiService.searchRentalCollectionByBSNewList(params);

    List<DtRentalCollectionListDto> list = DtRentalCollectionList.stream().map(r -> DtRentalCollectionListDto.create(r)).collect(Collectors.toList());

    return ResponseEntity.ok(list);
  }

  @ApiOperation(value = "select Submission Records", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/selectSubmissionRecords", method = RequestMethod.GET)
  public ResponseEntity<AsFromCodyDto> selectSubmissionRecords(@ModelAttribute AsFromCodyForm asFromCodyForm) throws Exception {
    return ResponseEntity.ok(asFromCodyApiService.selectSubmissionRecords(asFromCodyForm));
  }

  @SuppressWarnings("static-access")
  @ApiOperation(value = "select Order Info", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/selectOrderInfo", method = RequestMethod.GET)
  public ResponseEntity<AsFromCodyDto> selectOrderInfo(@ModelAttribute AsFromCodyForm asFromCodyForm) throws Exception {
    Map<String, Object> params = asFromCodyForm.createMap(asFromCodyForm);
    EgovMap resultMap = null;
    resultMap = asFromCodyApiService.selectOrderInfo(params);
    if (resultMap != null) {
      return ResponseEntity.ok(AsFromCodyDto.create(resultMap));
    } else {
      return ResponseEntity.ok(null);
    }
  }

  @ApiOperation(value = "Insert As From Cody Request", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/insertAsFromCodyRequest", method = RequestMethod.POST)
  public void insertAsFromCodyRequest(@RequestBody AsFromCodyForm asFromCodyForm) throws Exception {
    asFromCodyApiService.insertAsFromCodyRequest(asFromCodyForm);
  }

  @SuppressWarnings("static-access")
  @ApiOperation(value = "selectSubmissionRecordsAll List", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/selectSubmissionRecordsAll", method = RequestMethod.GET)
  public ResponseEntity<List<AsFromCodyDto>> selectSubmissionRecordsAll(@ModelAttribute AsFromCodyForm asFromCodyForm) throws Exception {

    Map<String, Object> params = asFromCodyForm.createMap(asFromCodyForm);
    List<EgovMap> selectSubmissionRecordsAll = null;

    selectSubmissionRecordsAll = asFromCodyApiService.selectSubmissionRecordsAll(params);

    List<AsFromCodyDto> recordtList = selectSubmissionRecordsAll.stream().map(r -> AsFromCodyDto.create(r)).collect(Collectors.toList());

    return ResponseEntity.ok(recordtList);
  }

  @SuppressWarnings("static-access")
  @ApiOperation(value = "SYSTEM GPS UPDATED", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/updateGPS", method = RequestMethod.POST)
  public ResponseEntity<ArrayList<String>> systemGpsUpdate(@RequestBody UpdateGPSForm UpdateGPSForm) throws Exception {
    Map<String, Object> params = UpdateGPSForm.createMap(UpdateGPSForm);

    JsonObject rtnUpdateGpsObj = new JsonObject();
    rtnUpdateGpsObj = MSvcLogApiService.updateGPS(params);

    ArrayList<String> rtn = new ArrayList<String>();
    rtn.add(0, (String) rtnUpdateGpsObj.get("oRtnCode").toString());
    rtn.add(1, (String) params.get("currentGpsValLat"));
    rtn.add(2, (String) params.get("currentGpsValLong"));
    rtn.add(3, (String) rtnUpdateGpsObj.get("oRtnMsg").toString());

    return ResponseEntity.ok(rtn);
  }

  @SuppressWarnings("static-access")
  @ApiOperation(value = "CHECK IN MILEAGE", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/checkInMileage", method = RequestMethod.POST)
  public ResponseEntity<List<EgovMap>> checkInMileage(@RequestBody ServiceMileageForm serviceMileageForm) throws Exception {

     Map<String, Object> params = serviceMileageForm.createMap(serviceMileageForm);
     List<EgovMap> checkInMileageStat = null;

     checkInMileageStat = serviceMileageApiService.checkInMileage(params);

     return ResponseEntity.ok(checkInMileageStat);
  }

  @ApiOperation(value = "GET CUSTOMER NRIC", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
  @RequestMapping(value = "/getCustNRIC", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> getCustNRIC(@RequestParam Map<String, Object> params) throws Exception {
    List<EgovMap> getCustNRIC = MSvcLogApiService.getCustNRIC(params);

    return ResponseEntity.ok(getCustNRIC);
  }
  /* OTHER - END */
}
