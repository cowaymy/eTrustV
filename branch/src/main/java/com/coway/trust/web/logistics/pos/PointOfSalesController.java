package com.coway.trust.web.logistics.pos;

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

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
import com.coway.trust.api.mobile.common.CommonConstants;
import com.coway.trust.biz.application.FileApplication;
import com.coway.trust.biz.common.FileVO;
import com.coway.trust.biz.common.type.FileType;
import com.coway.trust.biz.logistics.pointofsales.PointOfSalesService;
import com.coway.trust.cmmn.file.EgovFileUploadUtil;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.handler.SessionHandler;
import com.coway.trust.util.EgovFormBasedFileVo;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/*********************************************************************************************
 * DATE          PIC        VERSION     COMMENT
 *--------------------------------------------------------------------------------------------
 * 09/10/2019    ONGHC      1.0.1       - AMEND FOR LATEST CHANGES
 *********************************************************************************************/

@Controller
@RequestMapping(value = "/logistics/pos")
public class PointOfSalesController {

  private final Logger logger = LoggerFactory.getLogger(this.getClass());

  @Value("${app.name}")
  private String appName;

  @Value("${com.file.upload.path}")
  private String uploadDir;
  @Value("${web.resource.upload.file}")
  private String uploadDirWeb;

  @Resource(name = "PointOfSalesService")
  private PointOfSalesService PointOfSalesService;

  @Autowired
  private MessageSourceAccessor messageAccessor;

  @Autowired
  private SessionHandler sessionHandler;

  @Autowired
  private FileApplication fileApplication;

  @RequestMapping(value = "/PointOfSalesList.do")
  public String poslist(Model model, HttpServletRequest request, HttpServletResponse response) throws Exception {

    String reqno = request.getParameter("reqno");
    String reqtype = request.getParameter("reqtype");
    String reqloc = request.getParameter("reqloc");

    Date date = new Date();
    SimpleDateFormat df = new SimpleDateFormat("ddMMyyyy", Locale.getDefault(Locale.Category.FORMAT));
    String today = df.format(date);

    List<EgovMap> trxTyp = PointOfSalesService.getTrxTyp(null);

    Map<String, Object> map = new HashMap();
    map.put("reqno", reqno);
    map.put("reqtype", reqtype);
    map.put("reqloc", reqloc);
    map.put("today", today);

    model.addAttribute("searchVal", map);
    model.addAttribute("trxTyp", trxTyp);

    return "logistics/Pos/PointOfSalesList";
  }

  @RequestMapping(value = "/getAdjLoc.do")
  public String getAdjLoc(@RequestParam Map<String, Object> params, ModelMap model)  throws Exception {

    logger.debug("===========================/getAdjLoc.do===============================");
    logger.debug("== params " + params.toString());
    logger.debug("===========================/getAdjLoc.do===============================");

    return "logistics/Pos/PointOfSalesLocPop";
  }

  @RequestMapping(value = "/PosOfSalesIns.do")
  public String posins(@RequestParam Map<String, Object> params, ModelMap model)  throws Exception {
    logger.debug("===========================/PosOfSalesIns.do===============================");
    logger.debug("== params " + params.toString());
    logger.debug("===========================/PosOfSalesIns.do===============================");

    List<EgovMap> trxTyp = PointOfSalesService.getTrxTyp(params);

    model.addAttribute("trxTyp", trxTyp);

    return "logistics/Pos/PointOfSalesIns";
  }

  @RequestMapping(value = "/PosView.do", method = RequestMethod.POST)
  public String PosView(Model model, HttpServletRequest request, HttpServletResponse response) throws Exception {
    String streq = request.getParameter("streq");
    String sttype = request.getParameter("sttype");
    String smtype = request.getParameter("smtype");
    String tlocation = request.getParameter("tlocation");
    String flocation = request.getParameter("flocation");
    String crtsdt = request.getParameter("crtsdt");
    String crtedt = request.getParameter("crtedt");
    String reqsdt = request.getParameter("reqsdt");
    String reqedt = request.getParameter("reqedt");
    String sam = request.getParameter("sam");
    String sstatus = request.getParameter("sstatus");
    String rStcode = request.getParameter("rStcode");

    Map<String, Object> map = new HashMap<String, Object>();
    map.put("streq", streq);
    map.put("sttype", sttype);
    map.put("smtype", smtype);
    map.put("tlocation", tlocation);
    map.put("flocation", flocation);
    map.put("crtsdt", crtsdt);
    map.put("crtedt", crtedt);
    map.put("reqsdt", reqsdt);
    map.put("reqedt", reqedt);
    map.put("sam", sam);
    map.put("sstatus", sstatus);

    List<EgovMap> trxTyp = PointOfSalesService.getTrxTyp(null);
    model.addAttribute("trxTyp", trxTyp);

    model.addAttribute("searchVal", map);
    model.addAttribute("rStcode", rStcode);

    return "logistics/Pos/PointOfSalesView";
  }

  @RequestMapping(value = "/SearchSessionInfo.do", method = RequestMethod.GET)
  public ResponseEntity<Map> SearchSessionInfo(@RequestParam Map<String, Object> params, Model model) throws Exception {
    SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
    String UserName;
    String UserCode;
    int UserBranchId;
    if (sessionVO == null) {
      UserName = "ham";
    } else {
      UserName = sessionVO.getUserName();
    }
    if (sessionVO == null) {
      UserBranchId = 4;
      UserCode = "T010";
    } else {
      UserBranchId = sessionVO.getUserBranchId();
      UserCode = "T010";
    }

    // logger.debug("UserName 값 : {}", UserName);
    // logger.debug("UserCode 값 : {}", UserCode);
    // logger.debug("UserBranchId 값 : {}", UserBranchId);

    Map<String, Object> map = new HashMap();
    map.put("UserName", UserName);
    map.put("UserCode", UserCode);
    map.put("UserBranchId", UserBranchId);

    return ResponseEntity.ok(map);
  }

  @RequestMapping(value = "/PosSearchList.do", method = RequestMethod.POST)
  public ResponseEntity<Map> PosSearchList(@RequestBody Map<String, Object> params, Model model) throws Exception {

    String Status = (String) params.get("searchStatus");
    params.put("searchStatus", Status);
    String crtsdt = (String) params.get("crtsdt");
    crtsdt = crtsdt.replace("/", "");
    String crtedt = (String) params.get("crtedt");
    crtedt = crtedt.replace("/", "");
    String reqsdt = (String) params.get("reqsdt");
    reqsdt = reqsdt.replace("/", "");
    String reqedt = (String) params.get("reqedt");
    reqedt = reqedt.replace("/", "");
    params.put("crtsdt", crtsdt);
    params.put("crtedt", crtedt);
    params.put("reqsdt", reqsdt);
    params.put("reqedt", reqedt);

    List<EgovMap> list = PointOfSalesService.PosSearchList(params);

    Map<String, Object> map = new HashMap();
    map.put("data", list);

    return ResponseEntity.ok(map);
  }

  @RequestMapping(value = "/PosItemList.do", method = RequestMethod.GET)
  public ResponseEntity<Map> PosItemList(Model model, HttpServletRequest request, HttpServletResponse response)
      throws Exception {

    String[] PosItemType = request.getParameterValues("PosItemType");
    String[] catetype = request.getParameterValues("catetype");
    String reqLoc = request.getParameter("reqLoc");
    String mcode = request.getParameter("materialCode");

    Map<String, Object> smap = new HashMap();
    smap.put("ctype", PosItemType);
    smap.put("catetype", catetype);
    smap.put("reqLoc", reqLoc);
    smap.put("mcode", mcode);

    List<EgovMap> list = PointOfSalesService.posItemList(smap);

    smap.put("data", list);

    return ResponseEntity.ok(smap);
  }

  @RequestMapping(value = "/getRqstLocLst.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> getRqstLocLst(@RequestParam Map<String, Object> params) {

    logger.debug("===========================/getRqstLocLst.do===============================");
    logger.debug("== params " + params.toString());
    logger.debug("===========================/getRqstLocLst.do===============================");

    String searchgb = (String) params.get("locTyp");
    String[] searchgbvalue = searchgb.split("∈");
    params.put("locTypLst", searchgbvalue);

    List<EgovMap> list = PointOfSalesService.getRqstLocLst(params);

    return ResponseEntity.ok(list);

  }

  @RequestMapping(value = "/selectTypeList.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectTypeList(@RequestParam Map<String, Object> params) {
    logger.debug("===========================/selectTypeList.do===============================");
    logger.debug("== params " + params.toString());
    logger.debug("===========================/selectTypeList.do===============================");

    List<EgovMap> list = PointOfSalesService.selectTypeList(params);
    return ResponseEntity.ok(list);
  }

  @RequestMapping(value = "/selectAdjRsn.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectAdjRsn(@RequestParam Map<String, Object> params) {
    logger.debug("===========================/selectAdjRsn.do===============================");
    logger.debug("== params " + params.toString());
    logger.debug("===========================/selectAdjRsn.do===============================");

    List<EgovMap> list = PointOfSalesService.selectAdjRsn(params);
    return ResponseEntity.ok(list);
  }

  @RequestMapping(value = "/PointOfSalesSerialCheck.do", method = RequestMethod.GET)
  public ResponseEntity<Map> PointOfSalesSerialCheck(@RequestParam Map<String, Object> params) {
    logger.debug("===========================/PointOfSalesSerialCheck.do===============================");
    logger.debug("== params " + params.toString());
    logger.debug("===========================/PointOfSalesSerialCheck.do===============================");

    List<EgovMap> list = PointOfSalesService.selectPointOfSalesSerial(params);
    Map<String, Object> rmap = new HashMap<String, Object>();

    for (int i = 0; i < list.size(); i++) {
      logger.debug("serialList@: {}", list.get(i));
    }

    rmap.put("data", list);
    return ResponseEntity.ok(rmap);
  }

  @RequestMapping(value = "/insertPosInfo.do", method = RequestMethod.POST)
  public ResponseEntity<ReturnMessage> insertPosInfo(@RequestBody Map<String, Object> params, Model model) {
    logger.debug("===========================/insertPosInfo.do===============================");
    logger.debug("== params " + params.toString());
    logger.debug("===========================/insertPosInfo.do===============================");

    SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
    int loginId = sessionVO.getUserId();
    params.put("userId", loginId);

    String posSeq = PointOfSalesService.insertPosInfo(params);

    Map<String, Object> rmap = new HashMap();
    rmap.put("data", posSeq);

    ReturnMessage message = new ReturnMessage();
    message.setCode(AppConstants.SUCCESS);
    message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
    message.setData(posSeq);

    return ResponseEntity.ok(message);
  }

  @RequestMapping(value = "/PosGiSave.do", method = RequestMethod.POST)
  public ResponseEntity<ReturnMessage> PosGiSave(@RequestBody Map<String, Object> params, Model model) {
    logger.debug("===========================/PosGiSave.do===============================");
    logger.debug("== params " + params.toString());
    logger.debug("===========================/PosGiSave.do===============================");

    String reVal = "";
    int poschk = PointOfSalesService.selectOtherReqChk(params);

    logger.debug("== poschk " + poschk);

    SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
    int loginId = sessionVO.getUserId();
    params.put("userId", loginId);

    if (poschk > 0) {
      logger.debug("It's already in progress..");
    } else {
      reVal = PointOfSalesService.insertGiInfo(params);
    }

    Map<String, Object> map = new HashMap();
    map.put("reVal", reVal);
    map.put("poschk", poschk);

    ReturnMessage message = new ReturnMessage();
    message.setCode(AppConstants.SUCCESS);
    // message.setData(reVal);
    message.setData(map);
    message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

    return ResponseEntity.ok(message);
  }

  @RequestMapping(value = "/PosDataDetail.do", method = RequestMethod.GET)
  public ResponseEntity<Map> StocktransferDataDetail(Model model, HttpServletRequest request,
      HttpServletResponse response) throws Exception {
    String rstonumber = request.getParameter("rStcode");
    Map<String, Object> map = PointOfSalesService.PosDataDetail(rstonumber);

    return ResponseEntity.ok(map);
  }

  @RequestMapping(value = "/ViewSerial.do", method = RequestMethod.GET)
  public ResponseEntity<Map> ViewSerial(Model model, HttpServletRequest request, HttpServletResponse response)
      throws Exception {
    String reqno = request.getParameter("reqno");
    String itmcd = request.getParameter("itmcd");

    Map<String, Object> serialmap = new HashMap();
    serialmap.put("reqno", reqno);
    serialmap.put("itmcd", itmcd);

    List<EgovMap> list = PointOfSalesService.selectSerial(serialmap);

    Map<String, Object> map = new HashMap();
    map.put("data", list);

    return ResponseEntity.ok(map);
  }

  @RequestMapping(value = "/MaterialDocumentList.do", method = RequestMethod.GET)
  public ResponseEntity<Map> selectStockMovementRequestDeliveryList(@RequestParam Map<String, Object> params,
      Model model) throws Exception {

    List<EgovMap> mtrList = PointOfSalesService.selectMaterialDocList(params);

    Map<String, Object> map = new HashMap();

    map.put("data2", mtrList);

    return ResponseEntity.ok(map);
  }

  @RequestMapping(value = "/insertFile.do", method = RequestMethod.POST)
  public ResponseEntity<Map> insertFile(MultipartHttpServletRequest request, @RequestParam Map<String, Object> params,
      Model model, SessionVO sessionVO) throws Exception {

    //List<EgovFormBasedFileVo> list = EgovFileUploadUtil.uploadFiles(request, uploadDir, "FileUpload", 1024 * 1024 * 5);
    List<EgovFormBasedFileVo> list = EgovFileUploadUtil.uploadFiles(request, uploadDirWeb, File.separator + "GIGRADJ" + File.separator + "DCF", AppConstants.UPLOAD_MAX_FILE_SIZE, true);

    String upId = (String) params.get("upId");
    logger.debug("upId : {}", upId);

    params.put(CommonConstants.USER_ID, sessionVO.getUserId());

    int fileGroupKey = fileApplication.commonAttachByUserId(FileType.WEB, FileVO.createList(list), params);
    logger.debug("fileGroupKey : {}", fileGroupKey);
    params.put("fileGroupKey", fileGroupKey);
    logger.debug("params : {}", params);

    Map<String, Object> map = new HashMap<String, Object>();

    map.put("list", list);
    map.put("keyvalue", fileGroupKey);
    return ResponseEntity.ok(map);
  }

  @RequestMapping(value = "/deleteStoNo.do", method = RequestMethod.GET)
  public ResponseEntity<ReturnMessage> deleteStoNo(@RequestParam Map<String, Object> params, Model model) {
    logger.debug("===========================/deleteStoNo.do===============================");
    logger.debug("== params " + params.toString());
    logger.debug("===========================/deleteStoNo.do===============================");

    PointOfSalesService.deleteStoNo(params);

    ReturnMessage message = new ReturnMessage();
    message.setCode(AppConstants.SUCCESS);
    message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

    return ResponseEntity.ok(message);
  }

  @RequestMapping(value = "/getAttch.do", method = RequestMethod.GET)
  public ResponseEntity<Map<String, Object>> getAttch(@RequestParam Map<String, Object> params, ModelMap model) {
    Map<String, Object> fileInfo = PointOfSalesService.selectAttachmentInfo(params);

    return ResponseEntity.ok(fileInfo);
  }

  // KR-OHK Serial add
  @RequestMapping(value = "/selectReqItemList.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectReqItemList(@RequestParam Map<String, Object> params) {

    logger.debug("===========================/selectReqItemList.do===============================");
    logger.debug("== params " + params.toString());
    logger.debug("===========================/selectReqItemList.do===============================");

    List<EgovMap> list = PointOfSalesService.selectReqItemList((String)params.get("taskType"), (String)params.get("reqstNo"));

    return ResponseEntity.ok(list);

  }

  // KR-OHK Serial add
  @RequestMapping(value = "/PosGiSaveSerial.do", method = RequestMethod.POST)
  public ResponseEntity<ReturnMessage> PosGiSaveSerial(@RequestBody Map<String, Object> params, Model model) {
    logger.debug("===========================/PosGiSaveSerial.do===============================");
    logger.debug("== params " + params.toString());
    logger.debug("===========================/PosGiSaveSerial.do===============================");

    String reVal = "";
    int poschk = PointOfSalesService.selectOtherReqChk(params);

    logger.debug("== poschk " + poschk);

    SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
    int loginId = sessionVO.getUserId();
    params.put("userId", loginId);

    if (poschk > 0) {
        logger.debug("It's already in progress..");
    } else {
        reVal = PointOfSalesService.insertGiInfoSerial(params);
    }

    Map<String, Object> map = new HashMap();
    map.put("reVal", reVal);
    map.put("poschk", poschk);

    ReturnMessage message = new ReturnMessage();
    message.setCode(AppConstants.SUCCESS);
    // message.setData(reVal);
    message.setData(map);
    message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

    return ResponseEntity.ok(message);
  }

  // KR-OHK Serial add
  @RequestMapping(value = "/deleteStoNoSerial.do", method = RequestMethod.GET)
  public ResponseEntity<ReturnMessage> deleteStoNoSerial(@RequestParam Map<String, Object> params, Model model, SessionVO sessionVO) {
    logger.debug("===========================/deleteStoNoSerial.do===============================");
    logger.debug("== params " + params.toString());
    logger.debug("===========================/deleteStoNoSerial.do===============================");

    params.put("userId", sessionVO.getUserId());

    PointOfSalesService.deleteStoNoSerial(params);

    ReturnMessage message = new ReturnMessage();
    message.setCode(AppConstants.SUCCESS);
    message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

    return ResponseEntity.ok(message);
  }

}
