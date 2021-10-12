package com.coway.trust.web.logistics.returnusedparts;

import java.util.HashMap;
import java.util.List;
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

import com.coway.trust.AppConstants;
import com.coway.trust.biz.logistics.returnusedparts.ReturnASUsedPartsService;
import com.coway.trust.biz.logistics.totalstock.TotalStockService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.handler.SessionHandler;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/*********************************************************************************************
 * DATE          PIC        VERSION     COMMENT
 *--------------------------------------------------------------------------------------------
 * 18/12/2019    ONGHC      1.0.1       - Create AS Used Filter
 * 18/12/2019    ONGHC      1.0.2       - Amend returnPartsList to add AS Type
 *********************************************************************************************/

@Controller
@RequestMapping(value = "/logistics/returnasusedparts")
public class ReturnASUsedPartsController {

  private final Logger logger = LoggerFactory.getLogger(this.getClass());

  @Value("${app.name}")
  private String appName;

  @Resource(name = "returnASUsedPartsService")
  private ReturnASUsedPartsService returnASUsedPartsService;

  @Autowired
  private MessageSourceAccessor messageAccessor;

  @Autowired
  private SessionHandler sessionHandler;

  @RequestMapping(value = "/ReturnUsedParts.do")
  public String totalstock(Model model, HttpServletRequest request, HttpServletResponse response) throws Exception {
    return "logistics/returnUsedParts/returnASUsedPartsList";
  }

  @RequestMapping(value = "/ReturnUsedPartsTest.do")
  public ResponseEntity<ReturnMessage> returnUsedPartsTest(Model model, HttpServletRequest request,
      HttpServletResponse response) throws Exception {

    String str = request.getParameter("param");

    returnASUsedPartsService.returnPartsInsert(str);

    ReturnMessage message = new ReturnMessage();
    message.setCode(AppConstants.SUCCESS);
    message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

    return ResponseEntity.ok(message);

  }

  @RequestMapping(value = "/ReturnUsedPartsDelTest.do")
  public ResponseEntity<ReturnMessage> returnUsedPartsDelTest(Model model, HttpServletRequest request,
      HttpServletResponse response) throws Exception {

    String str = request.getParameter("param");

    returnASUsedPartsService.returnPartsdelete(str);

    ReturnMessage message = new ReturnMessage();
    message.setCode(AppConstants.SUCCESS);
    message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

    return ResponseEntity.ok(message);

  }

  @RequestMapping(value = "/returnPartsSearchList.do", method = RequestMethod.GET)
  public ResponseEntity<Map> returnPartsList(Model model, HttpServletRequest request, HttpServletResponse response) throws Exception {

    String searchOder = request.getParameter("searchOder");
    String searchCustomer = request.getParameter("searchCustomer");
    String searchMaterialCode = request.getParameter("searchMaterialCode");

    String searchBranch = request.getParameter("searchBranch");

    String servicesdt = request.getParameter("servicesdt");
    String serviceedt = request.getParameter("serviceedt");
    String returnsdt = request.getParameter("returnsdt");
    String returnedt = request.getParameter("returnedt");
    String searchMaterialType = request.getParameter("searchMaterialType");
    String searchComplete = request.getParameter("searchComplete");
    String searchDefTyp = request.getParameter("searchDefTyp");
    String[] searchDefCde = request.getParameterValues("searchDefCde");
    String[] searchSltCde = request.getParameterValues("searchSltCde");
    String[] searchLoc = request.getParameterValues("searchLoc");

    	String asTyp = request.getParameter("asTyp");

    logger.debug("===================================================");
    logger.debug("= searchBranch  : {}", searchBranch);
    logger.debug("= searchCustomer : {}", searchCustomer);
    logger.debug("= searchMaterialCode : {}", searchMaterialCode);
    logger.debug("= servicesdt : {}", servicesdt);
    logger.debug("= serviceedt : {}", serviceedt);
    logger.debug("= returnsdt  : {}", returnsdt);
    logger.debug("= returnedt : {}", returnedt);
    logger.debug("= searchMaterialType : {}", searchMaterialType);
    logger.debug("= searchComplete  : {}", searchComplete);
    logger.debug("= asTyp  : {}", asTyp);
    logger.debug("= searchDefTyp  : {}", searchDefTyp);
    logger.debug("= searchDefCde  : {}", searchDefCde);
    logger.debug("= searchSltCde  : {}", searchSltCde);
    logger.debug("= searchLoc  : {}", searchLoc);
    logger.debug("===================================================");

    Map<String, Object> smap = new HashMap();

    smap.put("searchOder", searchOder);
    smap.put("searchCustomer", searchCustomer);
    smap.put("searchBranch", searchBranch);
    smap.put("searchMaterialCode", searchMaterialCode);
    smap.put("servicesdt", servicesdt);
    smap.put("serviceedt", serviceedt);
    smap.put("returnsdt", returnsdt);
    smap.put("returnedt", returnedt);
    smap.put("searchMaterialType", searchMaterialType);
    smap.put("searchComplete", searchComplete);
    smap.put("searchLoc", searchLoc);
    smap.put("asTyp", asTyp);
    smap.put("searchDefTyp", searchDefTyp);
    smap.put("searchDefCde", searchDefCde);
    smap.put("searchSltCde", searchSltCde);

    logger.debug("smap : {}", smap);

    List<EgovMap> list = returnASUsedPartsService.returnPartsList(smap);

    Map<String, Object> map = new HashMap();
    map.put("data", list);

    return ResponseEntity.ok(map);
  }

  @RequestMapping(value = "/returnPartsUpdate.do", method = RequestMethod.POST)
  public ResponseEntity<ReturnMessage> returnPartsUpdate(@RequestBody Map<String, Object> params, Model model) {

    SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
    int loginId = sessionVO.getUserId();

    List<Object> checkList = (List<Object>) params.get(AppConstants.AUIGRID_CHECK);
    Map<String, Object> insMap = new HashMap<>();
    int dupCnt = 0;

    if (checkList.size() > 0) {
      for (int i = 0; i < checkList.size(); i++) {
        insMap = (Map<String, Object>) checkList.get(i);
      }
      dupCnt = returnASUsedPartsService.returnPartsdupchek(insMap);
    }

    if (dupCnt == 0) {
      returnASUsedPartsService.returnPartsUpdate(params, loginId);
    }

    ReturnMessage message = new ReturnMessage();
    message.setCode(AppConstants.SUCCESS);
    message.setMessage(messageAccessor.getMessage("service.msg.updSucc"));
    message.setData(dupCnt);

    return ResponseEntity.ok(message);
  }

  @RequestMapping(value = "/returnPartsCanCle.do", method = RequestMethod.POST)
  public ResponseEntity<ReturnMessage> returnPartsCanCle(@RequestBody Map<String, Object> params, Model model) {

    returnASUsedPartsService.returnPartsCanCle(params);

    ReturnMessage message = new ReturnMessage();
    message.setCode(AppConstants.SUCCESS);
    message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

    return ResponseEntity.ok(message);
  }

  @RequestMapping(value = "/validMatCodeSearch.do", method = RequestMethod.GET)
  public ResponseEntity<ReturnMessage> validMatCodeSearch(Model model, HttpServletRequest request,
      HttpServletResponse response) throws Exception {

    String matcode = request.getParameter("matcode");

    int matcodeCnt = returnASUsedPartsService.validMatCodeSearch(matcode);

    ReturnMessage message = new ReturnMessage();
    message.setCode(AppConstants.SUCCESS);
    message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
    message.setData(matcodeCnt);

    return ResponseEntity.ok(message);
  }

  @RequestMapping(value = "/HSUsedFilterListingPop.do")
  public String HSUsedFilterListingPop(@RequestParam Map<String, Object> params, ModelMap model) {

    List<EgovMap> rptTypList = returnASUsedPartsService.getRptType();
    List<EgovMap> rtnStat = returnASUsedPartsService.getRtnStat();
    model.put("rptTypList", rptTypList);
    model.put("rtnStat", rtnStat);

    return "logistics/returnUsedParts/ASUsedFilterListingPop";
  }

  @RequestMapping(value = "/getDeptCodeList")
  public ResponseEntity<List<EgovMap>> getDeptCodeList(@RequestParam Map<String, Object> params) throws Exception {

    List<EgovMap> deptCodeList = null;
    deptCodeList = returnASUsedPartsService.getDeptCodeList(params);

    return ResponseEntity.ok(deptCodeList);
  }

  @RequestMapping(value = "/getCodyCodeList")
  public ResponseEntity<List<EgovMap>> getCodyCodeList(@RequestParam Map<String, Object> params) throws Exception {

    List<EgovMap> codyCodeList = null;
    codyCodeList = returnASUsedPartsService.getCodyCodeList(params);

    return ResponseEntity.ok(codyCodeList);
  }

  @RequestMapping(value = "/selectBranchCodeList.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectBranchCodeList(@RequestParam Map<String, Object> params) {
    List<EgovMap> branchCodeList = returnASUsedPartsService.selectBranchCodeList(params);
    return ResponseEntity.ok(branchCodeList);
  }

  @RequestMapping(value = "/getBchBrowse.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> getBchBrowse(@RequestParam Map<String, Object> params) {
    List<EgovMap> branchCodeList = returnASUsedPartsService.getBchBrowse(params);
    return ResponseEntity.ok(branchCodeList);
  }

  @RequestMapping(value = "/getLoc.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> getLoc(@RequestParam Map<String, Object> params) {
    List<EgovMap> location = returnASUsedPartsService.getLoc(params);
    return ResponseEntity.ok(location);
  }

  @RequestMapping(value = "/getDefGrp.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> getDefGrp(@RequestParam Map<String, Object> params) {
    List<EgovMap> location = returnASUsedPartsService.getDefGrp(params);
    return ResponseEntity.ok(location);
  }

  @RequestMapping(value = "/getSltCde.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> getSltCde(@RequestParam Map<String, Object> params) {
    List<EgovMap> location = returnASUsedPartsService.getSltCde(params);
    return ResponseEntity.ok(location);
  }

  @RequestMapping(value = "/getProdCat.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> getProdCat(@RequestParam Map<String, Object> params) {
    List<EgovMap> location = returnASUsedPartsService.getProdCat(params);
    return ResponseEntity.ok(location);
  }

  @RequestMapping(value = "/getdefCde.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> getdefCde(@RequestParam Map<String, Object> params) {
    List<EgovMap> location = returnASUsedPartsService.getdefCde(params);
    return ResponseEntity.ok(location);
  }

}
