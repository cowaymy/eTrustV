package com.coway.trust.web.services.tagMgmt;

import java.io.File;
import java.text.ParseException;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.coway.trust.biz.services.tagMgmt.TagMgmtService;
import com.coway.trust.AppConstants;
import com.coway.trust.biz.application.FileApplication;
import com.coway.trust.biz.common.FileVO;
import com.coway.trust.biz.common.type.FileType;
import com.coway.trust.biz.sales.order.OrderDetailService;
import com.coway.trust.cmmn.file.EgovFileUploadUtil;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.util.EgovFormBasedFileVo;
import com.coway.trust.web.sales.SalesConstants;
import com.coway.trust.web.services.servicePlanning.MileageCalculationController;


import egovframework.rte.psl.dataaccess.util.EgovMap;

/*********************************************************************************************
 * DATE          PIC        VERSION     COMMENT
 *--------------------------------------------------------------------------------------------
 * 09/12/2019    ONGHC      1.0.1       - RE-STRUCTURE TagMgmtController
 *                                      - ADD FILE UPLOAD FUNCTION
 *********************************************************************************************/

@Controller
@RequestMapping(value = "/services/tagMgmt")
public class TagMgmtController {

  private static final Logger logger = LoggerFactory.getLogger(MileageCalculationController.class);

  @Value("${web.resource.upload.file}")
  private String uploadDir;

  @Resource(name = "tagMgmtService")
  TagMgmtService tagMgmtService;

  @Resource(name = "orderDetailService")
   private OrderDetailService orderDetailService;

  @Autowired
  private FileApplication fileApplication;

  @RequestMapping(value = "/tagManagement.do")
  public String viewTagMangement(@RequestParam Map<String, Object> params, ModelMap model) {
    model.addAttribute("params", params);

    List<EgovMap> tMgntStat = tagMgmtService.getTagMgntStat(params);
    String bfDay = CommonUtils.changeFormat(CommonUtils.getCalDate(-30), SalesConstants.DEFAULT_DATE_FORMAT3,
        SalesConstants.DEFAULT_DATE_FORMAT1);
    String toDay = CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT1);

    model.put("bfDay", bfDay);
    model.put("toDay", toDay);

    model.addAttribute("tMgntStat", tMgntStat);

    return "services/tagMgmt/tagMgmtList";
  }

  @RequestMapping(value = "/tagLogRegistPop.do")
  public String viewTagLogRegistPop(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO)
      throws Exception {
    model.addAttribute("params", params);

    EgovMap tagMgmtDetail = tagMgmtService.getDetailTagStatus(params);
    model.addAttribute("tagMgmtDetail", tagMgmtDetail);

    List<EgovMap> remarks = tagMgmtService.getTagRemark(params);
    model.addAttribute("remarks", remarks);

    EgovMap orderInfo = tagMgmtService.getOrderInfo(tagMgmtDetail);
    model.addAttribute("orderInfo", orderInfo);

    EgovMap callerInfo = tagMgmtService.getOrderInfo(tagMgmtDetail);
    model.addAttribute("callerInfo", callerInfo);

    EgovMap salesmanInfo = tagMgmtService.selectOrderSalesmanViewByOrderID(orderInfo);
    model.addAttribute("salesmanInfo", salesmanInfo);

    EgovMap codyInfo = tagMgmtService.selectOrderServiceMemberViewByOrderID(orderInfo);
    model.addAttribute("codyInfo", codyInfo);

    List<EgovMap> tMgntStat = tagMgmtService.getTagMgntStat(params);
    model.addAttribute("tMgntStat", tMgntStat);

    if (orderInfo != null) {
      params.put("salesOrderId", orderInfo.get("salesOrdId"));

      EgovMap orderDetail = orderDetailService.selectOrderBasicInfo(params, sessionVO);
      model.put("orderDetail", orderDetail);
    }

    return "services/tagMgmt/tagLogListPop";
  }

  @RequestMapping(value = "/selectTagStatus")
  ResponseEntity<List<EgovMap>> getTagStatus(@RequestParam Map<String, Object> params, HttpServletRequest request) {
    String[] statusList = request.getParameterValues("statusList");
    params.put("listStatus", statusList);
    List<EgovMap> notice = tagMgmtService.getTagStatus(params);
    return ResponseEntity.ok(notice);
  }

  @RequestMapping(value = "/getRemarkResults.do")
  ResponseEntity<List<EgovMap>> getRemarks(@RequestParam Map<String, Object> params) {
    List<EgovMap> remarks = tagMgmtService.getTagRemark(params);
    return ResponseEntity.ok(remarks);
  }

  @RequestMapping(value = "/addRemarkResult.do", method = RequestMethod.POST)
  public ResponseEntity<ReturnMessage> addRemarkResult(MultipartHttpServletRequest request,
      @RequestParam Map<String, Object> params, Model model, SessionVO sessionVO) throws Exception {

    ReturnMessage message = new ReturnMessage();

    logger.debug("== TAG MANAGEMENT SAVE PARAM {} ", params);

    List<EgovFormBasedFileVo> list = EgovFileUploadUtil.uploadFiles(request, uploadDir, File.separator + "hqTagMngmt" + File.separator + "hqTagMngmt", AppConstants.UPLOAD_MAX_FILE_SIZE, true);

    params.put("userId", sessionVO.getUserId());
    params.put("branchId", sessionVO.getUserBranchId());
    params.put("deptId", sessionVO.getUserDeptId());
    params.put("list", list);

    logger.debug("== TAG MANAGEMENT FILE LISTING {} ", list);
    logger.debug("== TAG MANAGEMENT FILE SIZE " + list.size());

    if (list.size() > 0) {
      params.put("fileName", list.get(0).getServerSubPath() + list.get(0).getFileName());
      int fileGroupKey = fileApplication.businessAttach(FileType.WEB, FileVO.createList(list), params);
      params.put("atchFileGrpId", fileGroupKey);
    }

    int remarkResult = tagMgmtService.addRemarkResult(params, sessionVO);

    if (remarkResult == 2) {
      message.setMessage("Result update sucessfully.");
    } else {
      message.setMessage("Fail to update result.");
    }

    return ResponseEntity.ok(message);
  }

  @RequestMapping(value = "/selectMainDept.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> getMainDeptList(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model) {
    List<EgovMap> mainDeptList = tagMgmtService.getMainDeptList();
    return ResponseEntity.ok(mainDeptList);
  }

  @RequestMapping(value = "/selectSubDept.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> getSubDept(@RequestParam Map<String, Object> params, HttpServletRequest request,
      ModelMap model) {
    List<EgovMap> subDeptList = tagMgmtService.getSubDeptList(params);
    return ResponseEntity.ok(subDeptList);
  }

  @RequestMapping(value = "/selectMainInquiry.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> getMainInquiryList(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model) {
    List<EgovMap> mainInquiryList = tagMgmtService.getMainInquiryList();

    return ResponseEntity.ok(mainInquiryList);
  }

  @RequestMapping(value = "/selectSubInquiry.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> getSubInquiryList(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model) {
    List<EgovMap> subInquiryList = tagMgmtService.getSubInquiryList(params);

    return ResponseEntity.ok(subInquiryList);
  }

  @RequestMapping(value = "/selectAttachList.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> getAttachList(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model) {
    List<EgovMap> attachList = tagMgmtService.getAttachList(params);

    return ResponseEntity.ok(attachList);
  }

  @RequestMapping(value = "/selectAttachList2.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> getAttachList2(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model) {
    List<EgovMap> attachList = tagMgmtService.getAttachList2(params);

    return ResponseEntity.ok(attachList);
  }
}
