package com.coway.trust.web.services.as;

import java.io.File;
import java.math.BigDecimal;
import java.util.Date;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.application.FileApplication;
import com.coway.trust.biz.common.FileVO;
import com.coway.trust.biz.common.type.FileType;
import com.coway.trust.biz.sales.order.OrderDetailService;
import com.coway.trust.biz.services.as.ASManagementListService;
import com.coway.trust.biz.services.as.CompensationService;
import com.coway.trust.biz.services.tagMgmt.TagMgmtService;
import com.coway.trust.cmmn.file.EgovFileUploadUtil;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.EgovFormBasedFileVo;
import com.coway.trust.web.sales.SalesConstants;
import com.ibm.icu.text.DateFormat;
import com.ibm.icu.text.SimpleDateFormat;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/services/compensation")

/*********************************************************************************************
 * DATE          PIC        VERSION     COMMENT
 *--------------------------------------------------------------------------------------------
 * 01/04/2019    ONGHC      1.0.1       - Restructure File
 * 29/05/2019    ONGHC      1.0.2       - Amend uploadDir
 * 18/06/2019    ONGHC      1.0.3       - Amend based on user request
 *********************************************************************************************/

public class CompensationController {
  private static final Logger logger = LoggerFactory.getLogger(CompensationController.class);

  @Value("${web.resource.upload.file}")
  private String uploadDir;

  @Resource(name = "CompensationService")
  private CompensationService compensationService;

  @Resource(name = "orderDetailService")
  private OrderDetailService orderDetailService;

  @Resource(name = "ASManagementListService")
  private ASManagementListService ASManagementListService;

  @Resource(name = "tagMgmtService")
  TagMgmtService tagMgmtService;

  @Autowired
  private MessageSourceAccessor messageAccessor;

  @Autowired
  private FileApplication fileApplication;

  @RequestMapping(value = "/compensationList.do")
  public String main(@RequestParam Map<String, Object> params, ModelMap model) {
    List<EgovMap> branchWithNMList = compensationService.selectBranchWithNM();
    List<EgovMap> mainDeptList = compensationService.getMainDeptList();
    List<EgovMap> cpsStatus = compensationService.selectCpsStatus();
    List<EgovMap> cpsTyp = compensationService.selectCpsTyp();
    List<EgovMap> cpsRespTyp = compensationService.selectCpsRespTyp();
    List<EgovMap> cpsCocTyp = compensationService.selectCpsCocTyp();
    List<EgovMap> cpsEvtTyp = compensationService.selectCpsEvtTyp();

    model.put("branchWithNMList", branchWithNMList);
    model.put("mainDeptList", mainDeptList);
    model.put("cpsStatus", cpsStatus);
    model.put("cpsTyp", cpsTyp);
    model.put("cpsRespTyp", cpsRespTyp);
    model.put("cpsCocTyp", cpsCocTyp);
    model.put("cpsEvtTyp", cpsEvtTyp);

    return "services/as/compensationList";
  }

  /*@RequestMapping(value = "/compensationAddPop.do")
  public String addPop(@RequestParam Map<String, Object> params, ModelMap model) {

    logger.debug("============================COMPENSATION SEARCH - START==================================");

    List<EgovMap> branchWithNMList = compensationService.selectBranchWithNM();
    List<EgovMap> mainDeptList = tagMgmtService.getMainDeptList();

    model.put("branchWithNMList", branchWithNMList);
    model.put("mainDeptList", mainDeptList);

    logger.debug("============================COMPENSATION SEARCH - END==================================");
    return "services/as/compensationAddPop";
  }*/

  @RequestMapping(value = "/compensationAddPop.do")
  public String compensationAddPop(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) throws Exception {
    logger.debug("===========================COMPENSATION ENTRY - START================================");
    logger.debug("== params " + params.toString());

    params.put("orderNo", params.get("ordNo"));
    params.put("salesOrderId", params.get("ordId"));

    EgovMap orderDetail = orderDetailService.selectOrderBasicInfo(params, sessionVO);
    EgovMap as_ord_basicInfo = ASManagementListService.selectOrderBasicInfo(params);

    EgovMap tempMap = null;
    tempMap = (EgovMap)orderDetail.get("basicInfo");
    String stkCode = (String)tempMap.get("stockCode");

    List<EgovMap> branchWithNMList = compensationService.selectBranchWithNM();
    List<EgovMap> mainDeptList = compensationService.getMainDeptList();
    List<EgovMap> cpsStatus = compensationService.selectCpsStatus();
    List<EgovMap> cpsTyp = compensationService.selectCpsTyp();
    List<EgovMap> cpsRespTyp = compensationService.selectCpsRespTyp();
    List<EgovMap> cpsCocTyp = compensationService.selectCpsCocTyp();
    List<EgovMap> cpsEvtTyp = compensationService.selectCpsEvtTyp();
    List<EgovMap> cpsDftTyp = compensationService.selectCpsDftTyp(stkCode);

    model.put("orderDetail", orderDetail);
    model.put("as_ord_basicInfo", as_ord_basicInfo);
    model.put("branchWithNMList", branchWithNMList);
    model.put("mainDeptList", mainDeptList);
    model.put("cpsStatus", cpsStatus);
    model.put("cpsTyp", cpsTyp);
    model.put("cpsRespTyp", cpsRespTyp);
    model.put("cpsCocTyp", cpsCocTyp);
    model.put("cpsEvtTyp", cpsEvtTyp);
    model.put("cpsDftTyp", cpsDftTyp);

    if (orderDetail != null) {
      logger.debug("== orderDetail " + orderDetail.toString());
    }
    if (as_ord_basicInfo != null) {
      logger.debug("== orderBasicInfo " + as_ord_basicInfo.toString());
    }

    return "services/as/compensationAddPop";
  }

  @RequestMapping(value = "/compensationOrdSearchPop.do")
  public String compensationOrdSearchPop(@RequestParam Map<String, Object> params, ModelMap model) {
    logger.debug("===========================COMPENSATION ORDER SELECTION - START===============================");
    logger.debug("== params " + params.toString());
    logger.debug("===========================COMPENSATION ORDER SELECTION - END===============================");

    return "services/as/compensationOrdSearchPop";
  }

  @RequestMapping(value = "/verifyOrdNo.do", method = RequestMethod.GET)
  //public ResponseEntity<ReturnMessage> verifyOrdNo(MultipartHttpServletRequest request, @RequestParam Map<String, Object> params, Model model, SessionVO sessionVO) throws Exception {
  public ResponseEntity<EgovMap> verifyOrdNo(@RequestParam Map<String, Object> params, ModelMap model) {
    logger.debug("===========================VERIFY SELECTED ORDER NUMBER - START===============================");
    logger.debug("== params " + params.toString());

    // VERIFY SELECTED ORDER NUMBER HERE
    EgovMap ordInfo = compensationService.selectOrdInfo(params);

    logger.debug("===========================VERIFY SELECTED ORDER NUMBER - END===============================");
    return ResponseEntity.ok(ordInfo);
  }

  @RequestMapping(value = "/compensationEditPop.do")
  public String editPop(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) throws Exception {
    logger.debug("===========================EDIT COMPENSATION RECORD - START===============================");
    logger.debug("== params " + params.toString());

    params.put("cpsNo", params.get("cpsNo"));
    EgovMap compensationView = compensationService.selectCompenSationView(params);
    params.put("atchFileGrpId", compensationView.get("atchFileGrpId"));
    logger.debug("== compensationView : {} ", compensationView);

    params.put("orderNo", compensationView.get("ordNo"));
    params.put("salesOrderId", compensationView.get("ordId"));

    EgovMap orderDetail = orderDetailService.selectOrderBasicInfo(params, sessionVO);
    EgovMap as_ord_basicInfo = ASManagementListService.selectOrderBasicInfo(params);

    EgovMap tempMap = null;
    tempMap = (EgovMap)orderDetail.get("basicInfo");
    String stkCode = (String)tempMap.get("stockCode");

    List<EgovMap> files = compensationService.getAttachmentFileInfo(params);
    List<EgovMap> branchWithNMList = compensationService.selectBranchWithNM();
    List<EgovMap> mainDeptList = compensationService.getMainDeptList();
    List<EgovMap> cpsStatus = compensationService.selectCpsStatus();
    List<EgovMap> cpsTyp = compensationService.selectCpsTyp();
    List<EgovMap> cpsRespTyp = compensationService.selectCpsRespTyp();
    List<EgovMap> cpsCocTyp = compensationService.selectCpsCocTyp();
    List<EgovMap> cpsEvtTyp = compensationService.selectCpsEvtTyp();
    List<EgovMap> cpsDftTyp = compensationService.selectCpsDftTyp(stkCode);

    model.put("orderDetail", orderDetail);
    model.put("as_ord_basicInfo", as_ord_basicInfo);
    model.put("compensationView", compensationView);
    model.put("branchWithNMList", branchWithNMList);
    model.put("mainDeptList", mainDeptList);
    model.put("compNo", params.get("compNo"));
    model.put("cpsStatus", cpsStatus);
    model.put("cpsTyp", cpsTyp);
    model.put("cpsRespTyp", cpsRespTyp);
    model.put("cpsCocTyp", cpsCocTyp);
    model.put("cpsEvtTyp", cpsEvtTyp);
    model.put("cpsDftTyp", cpsDftTyp);
    model.put("files", files);

    return "services/as/compensationEditPop";
  }

  @RequestMapping(value = "/compensationViewPop.do")
  public String viewPop(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) throws Exception {

    logger.debug("============================COMPENSATION VIEW - START==================================");
    logger.debug("= PARAMS : {}", params);

    EgovMap compensationView = compensationService.selectCompenSationView(params);
    params.put("atchFileGrpId", compensationView.get("atchFileGrpId"));

    params.put("orderNo", compensationView.get("ordNo"));
    params.put("salesOrderId", compensationView.get("ordId"));

    EgovMap orderDetail = orderDetailService.selectOrderBasicInfo(params, sessionVO);
    EgovMap as_ord_basicInfo = ASManagementListService.selectOrderBasicInfo(params);

    EgovMap tempMap = null;
    tempMap = (EgovMap)orderDetail.get("basicInfo");
    String stkCode = (String)tempMap.get("stockCode");

    List<EgovMap> files = compensationService.getAttachmentFileInfo(params);
    List<EgovMap> branchWithNMList = compensationService.selectBranchWithNM();
    List<EgovMap> mainDeptList = compensationService.getMainDeptList();
    List<EgovMap> cpsStatus = compensationService.selectCpsStatus();
    List<EgovMap> cpsTyp = compensationService.selectCpsTyp();
    List<EgovMap> cpsRespTyp = compensationService.selectCpsRespTyp();
    List<EgovMap> cpsCocTyp = compensationService.selectCpsCocTyp();
    List<EgovMap> cpsEvtTyp = compensationService.selectCpsEvtTyp();
    List<EgovMap> cpsDftTyp = compensationService.selectCpsDftTyp(stkCode);

    model.put("orderDetail", orderDetail);
    model.put("as_ord_basicInfo", as_ord_basicInfo);
    model.put("compensationView", compensationView);
    model.put("branchWithNMList", branchWithNMList);
    model.put("mainDeptList", mainDeptList);
    model.put("cpsNo", params.get("cpsNo"));
    model.put("cpsStatus", cpsStatus);
    model.put("cpsTyp", cpsTyp);
    model.put("cpsRespTyp", cpsRespTyp);
    model.put("cpsCocTyp", cpsCocTyp);
    model.put("cpsEvtTyp", cpsEvtTyp);
    model.put("cpsDftTyp", cpsDftTyp);
    model.put("files", files);

    logger.debug("============================COMPENSATION VIEW - END==================================");

    return "services/as/compensationViewPop";
  }

  @RequestMapping(value = "/selCompensation.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selInhouseList(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model) {

    logger.debug("============================COMPENSATION SEARCH - START==================================");
    logger.debug("= PARAMS : {}", params);

    List<EgovMap> mList = compensationService.selCompensationList(params);

    logger.debug("= RESULT : {}", mList);
    logger.debug("============================COMPENSATION SEARCH - END==================================");

    return ResponseEntity.ok(mList);
  }

  @SuppressWarnings("null")
  @RequestMapping(value = "/insertCompensation.do", method = RequestMethod.POST)
  public ResponseEntity<EgovMap> insertCompensation(MultipartHttpServletRequest request,
      @RequestParam Map<String, Object> params, Model model, SessionVO sessionVO) throws Exception {

    params.put("updator", sessionVO.getUserId());

    logger.debug("============================COMPENSATION INSERT - START==================================");
    logger.debug("= PARAMS : {}", params);

    EgovMap resultValue = new EgovMap();

    // CHECK RESULT DUPLITCATE
    int count = compensationService.chkCpsRcd(params);

    if (count == 0) {
      List<EgovFormBasedFileVo> list = EgovFileUploadUtil.uploadFiles(request,
          uploadDir, File.separator + "compensation" + File.separator + "DCF",
          AppConstants.UPLOAD_MAX_FILE_SIZE, true);

      params.put("userId", sessionVO.getUserId());
      params.put("branchId", sessionVO.getUserBranchId());
      params.put("deptId", sessionVO.getUserDeptId());
      params.put("list", list);

      logger.debug("== COMPENSATION FILE LISTING {} ", list);
      logger.debug("== COMPENSATION FILE SIZE " + list.size());

      if (list.size() > 0) {
        params.put("fileName", list.get(0).getServerSubPath() + list.get(0).getFileName());
        int fileGroupKey = fileApplication.businessAttach(FileType.WEB, FileVO.createList(list), params);
        params.put("atchFileGrpId", fileGroupKey);
      }

      SimpleDateFormat transFormat = new SimpleDateFormat("yyyyMMdd");
      //SimpleDateFormat transFormat1 = new SimpleDateFormat("yyyy-MM-dd");

      DateFormat sdFormat = new SimpleDateFormat("ddMMyyyy");
      //DateFormat sdFormat1 = new SimpleDateFormat("dd-MM-yyyy");

      String issue = (String) params.get("issueDt");
      String compdate = (String) params.get("compDt");
      String asRqstDt = (String) params.get("asRqstDt");
      if (!issue.equals("")) {
        params.put("issueDt", transFormat.format(sdFormat.parse(issue.replaceAll("/", ""))));
      }
      if (!compdate.equals("")) {
        params.put("compDt", transFormat.format(sdFormat.parse(compdate.replaceAll("/", ""))));
      }
      if (!asRqstDt.equals("")) {
        params.put("asRqstDt", transFormat.format(sdFormat.parse(asRqstDt.replaceAll("/", ""))));
      }

      resultValue = compensationService.insertCompensation(params);
    } else {
      resultValue.put("success", false);
      resultValue.put("code", "01");
      resultValue.put("message", "Selected Order Number, AS Number or ASR Number exist in Active or Pending Status.");
    }

    logger.debug("============================COMPENSATION INSERT - END==================================");

    return ResponseEntity.ok(resultValue);
  }

  @RequestMapping(value = "/updateCompensation.do", method = RequestMethod.POST)
  public ResponseEntity<ReturnMessage> updateCompensation(MultipartHttpServletRequest request,
      @RequestParam Map<String, Object> params, Model model, SessionVO sessionVO) throws Exception {
    params.put("updator", sessionVO.getUserId());
    params.put("userId", sessionVO.getUserId());
    params.put("branchId", sessionVO.getUserBranchId());
    params.put("deptId", sessionVO.getUserDeptId());

    logger.debug("============================COMPENSATION EDIT - START==================================");
    logger.debug("= PARAMS : {}", params);

    List<EgovFormBasedFileVo> list = EgovFileUploadUtil.uploadFiles(request, uploadDir, File.separator + "compensation" + File.separator + "DCF", AppConstants.UPLOAD_MAX_FILE_SIZE, true);
    params.put("list", list);

    SimpleDateFormat transFormat = new SimpleDateFormat("yyyyMMdd");
    DateFormat sdFormat = new SimpleDateFormat("ddMMyyyy");

    String issue = (String) params.get("issueDt");
    String compdate = (String) params.get("compDt");
    String asRqstDt = (String) params.get("asRqstDt");

    if (!issue.equals("")) {
      params.put("issueDt", transFormat.format(sdFormat.parse(issue.replaceAll("/", ""))));
    }
    if (!compdate.equals("")) {
      params.put("compDt", transFormat.format(sdFormat.parse(compdate.replaceAll("/", ""))));
    }
    if (!asRqstDt.equals("")) {
      params.put("asRqstDt", transFormat.format(sdFormat.parse(asRqstDt.replaceAll("/", ""))));
    }

    fileApplication.updateBusinessAttach(FileVO.createList(list), params);

    ReturnMessage message = new ReturnMessage();
    message.setCode(AppConstants.SUCCESS);
    message.setMessage("Compensation successfully updated.");
    logger.debug("============================COMPENSATION EDIT - START==================================");
    return ResponseEntity.ok(message);
  }
}
