/**
 *
 */
package com.coway.trust.web.sales.order;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.biz.misc.voucher.VoucherService;
import com.coway.trust.biz.sales.order.OrderDetailService;
import com.coway.trust.biz.services.bs.HsManualService;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.web.sales.SalesConstants;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @author Yunseok_Jang
 *
 */
@Controller
@RequestMapping(value = "/sales/order")
public class OrderDetailController {

  private static Logger logger = LoggerFactory.getLogger(OrderDetailController.class);

  @Value("${web.resource.upload.file}")
  private String uploadDir;

  @Resource(name = "orderDetailService")
  private OrderDetailService orderDetailService;

  @Resource(name = "hsManualService")
  private HsManualService hsManualService;

  @Resource(name = "voucherService")
  private VoucherService voucherService;

  @RequestMapping(value = "/orderDetailPop.do")
  public String getOrderDetailPop(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO)
      throws Exception {

    // params.put("salesOrderId", 256488);

    int prgrsId = 0;

    params.put("prgrsId", prgrsId);

    logger.debug("!@##############################################################################");
    logger.debug("!@###### salesOrderId : " + params.get("salesOrderId"));
    logger.debug("!@##############################################################################");

    // [Tap]Basic Info
    EgovMap orderDetail = orderDetailService.selectOrderBasicInfo(params, sessionVO);//

    model.put("orderDetail", orderDetail);

    return "sales/order/orderDetailPop";
  }

  @RequestMapping(value = "/selectBasicInfoJson.do", method = RequestMethod.GET)
  public ResponseEntity<EgovMap> selectBasicInfoJson(@RequestParam Map<String, Object> params, ModelMap model)
      throws Exception {

    logger.debug("!@##############################################################################");
    logger.debug("!@###### salesOrderId : " + params.get("salesOrderId"));
    logger.debug("!@##############################################################################");

    EgovMap basicInfo = orderDetailService.selectBasicInfo(params);

    if(basicInfo.get("voucherCode") != null
    		&& basicInfo.get("voucherCode").toString().length() > 0){
        Map<String,Object> voucherParam = new HashMap();
        voucherParam.put("voucherCode", basicInfo.get("voucherCode").toString());
        EgovMap voucherInfo = voucherService.getVoucherInfo(voucherParam);

        if(voucherInfo != null){
        	basicInfo.put("voucherInfo", voucherInfo);
        }
    };

    // 데이터 리턴.
    return ResponseEntity.ok(basicInfo);
  }

  @RequestMapping(value = "/selectSameRentalGrpOrderJsonList.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectSameRentalGrpOrderJsonList(@RequestParam Map<String, Object> params,
      ModelMap model) {

    logger.debug("!@##############################################################################");
    logger.debug("!@###### salesOrderId : " + params.get("salesOrderId"));
    logger.debug("!@##############################################################################");

    List<EgovMap> sameRentalGrpOrderJsonList = orderDetailService.selectSameRentalGrpOrderList(params);

    // 데이터 리턴.
    return ResponseEntity.ok(sameRentalGrpOrderJsonList);
  }

  @RequestMapping(value = "/selectMembershipInfoJsonList.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectMembershipInfoJsonList(@RequestParam Map<String, Object> params,
      ModelMap model) {

    logger.debug("!@##############################################################################");
    logger.debug("!@###### salesOrderId : " + params.get("salesOrderId"));
    logger.debug("!@##############################################################################");

    List<EgovMap> memInfoList = orderDetailService.selectMembershipInfoList(params);

    // 데이터 리턴.
    return ResponseEntity.ok(memInfoList);
  }

  @RequestMapping(value = "/selectDocumentJsonList.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectDocumentJsonList(@RequestParam Map<String, Object> params,
      ModelMap model) {

    logger.debug("!@##############################################################################");
    logger.debug("!@###### salesOrderId : " + params.get("salesOrderId"));
    logger.debug("!@##############################################################################");

    List<EgovMap> memInfoList = orderDetailService.selectDocumentList(params);

    // 데이터 리턴.
    return ResponseEntity.ok(memInfoList);
  }

  @RequestMapping(value = "/selectCallLogJsonList.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectCallLogJsonList(@RequestParam Map<String, Object> params, ModelMap model) {

    logger.debug("!@##############################################################################");
    logger.debug("!@###### salesOrderId : " + params.get("salesOrderId"));
    logger.debug("!@##############################################################################");

    List<EgovMap> memInfoList = orderDetailService.selectCallLogList(params);

    // 데이터 리턴.
    return ResponseEntity.ok(memInfoList);
  }

  @RequestMapping(value = "/selectPaymentJsonList.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectPaymentJsonList(@RequestParam Map<String, Object> params, ModelMap model) {

    logger.debug("!@##############################################################################");
    logger.debug("!@###### salesOrderId : " + params.get("salesOrderId"));
    logger.debug("!@##############################################################################");

    List<EgovMap> memInfoList = orderDetailService.selectPaymentMasterList(params);

    // 데이터 리턴.
    return ResponseEntity.ok(memInfoList);
  }

  @RequestMapping(value = "/selectAutoDebitJsonList.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectAutoDebitJsonList(@RequestParam Map<String, Object> params,
      ModelMap model) {
    List<EgovMap> memInfoList = orderDetailService.selectAutoDebitList(params);
    // 데이터 리턴.
    return ResponseEntity.ok(memInfoList);
  }

  @RequestMapping(value = "/selectEcashList.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectEcashList(@RequestParam Map<String, Object> params, ModelMap model) {
    List<EgovMap> result = orderDetailService.selectEcashList(params);
    // 데이터 리턴.
    return ResponseEntity.ok(result);
  }

  @RequestMapping(value = "/selectDiscountJsonList.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectDiscountJsonList(@RequestParam Map<String, Object> params,
      ModelMap model) {

    logger.debug("!@##############################################################################");
    logger.debug("!@###### salesOrderId : " + params.get("salesOrderId"));
    logger.debug("!@##############################################################################");

    List<EgovMap> memInfoList = orderDetailService.selectDiscountList(params);

    // 데이터 리턴.
    return ResponseEntity.ok(memInfoList);
  }

  @RequestMapping(value = "/selectLast6MonthTransJsonList.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectLast6MonthTransJsonList(@RequestParam Map<String, Object> params,
      ModelMap model) {

    List<EgovMap> resultList = orderDetailService.selectLast6MonthTransListNew(params);

    // 데이터 리턴.
    return ResponseEntity.ok(resultList);
  }

  @RequestMapping(value = "/selectCurrentBSResultByBSNo.do", method = RequestMethod.GET)
  public ResponseEntity<EgovMap> selectCurrentBSResultByBSNo(@RequestParam Map<String, Object> params) {
    EgovMap rslt = orderDetailService.selectCurrentBSResultByBSNo(params);
    return ResponseEntity.ok(rslt);
  }

  @RequestMapping(value = "/selectASInfoList.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectASInfoList(@RequestParam Map<String, Object> params, ModelMap model) {

    List<EgovMap> resultList = orderDetailService.selectASInfoList(params);

    // 데이터 리턴.
    return ResponseEntity.ok(resultList);
  }

  @RequestMapping(value = "/hsBasicInfoPop.do")
  public String selecthsBasicInfoPop(@RequestParam Map<String, Object> params, HttpServletRequest request,
      ModelMap model, SessionVO sessionVO) throws Exception {

    EgovMap basicinfo = null;

    params.put("salesOrderId", params.get("salesOrdId"));
    logger.debug("===========================================>");
    logger.debug("params : {}", params);
    logger.debug("===========================================>");

    basicinfo = hsManualService.selectHsViewBasicInfo(params);

    List<EgovMap> cmbCollectTypeComboList = hsManualService.cmbCollectTypeComboList(params);
    List<EgovMap> failReasonList = hsManualService.failReasonList(params);
    model.addAttribute("basicinfo", basicinfo);
    logger.debug("basicinfo : {}", basicinfo);
    model.addAttribute("cmbCollectTypeComboList", cmbCollectTypeComboList);
    model.addAttribute("failReasonList", failReasonList);
    model.addAttribute("MOD", params.get("MOD"));

    return "sales/order/include/hsEditPop";
  }

  @RequestMapping(value = "/getInstImg.do")
  public String getInstImg(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO)
      throws Exception {
    logger.debug("======================================================");
    logger.debug("= PARAMS : " + params.toString());
    logger.debug("======================================================");

    // GET IMAGE PATH
    List<EgovMap> imgLst = null;
    String type = "";
    String fileType = "";

    if ((CommonUtils.nvl(params.get("insNo")).equals(""))) {
      imgLst = orderDetailService.getInstImg(params);
    } else {
         imgLst = orderDetailService.getInstImgByInst(params);
    }

    if(imgLst !=null && imgLst.size() > 0){
      for(EgovMap imgInfo : imgLst){
        fileType = imgInfo.get("fileSubPath").toString().substring(8,11);
      }
    }

    //String type = CommonUtils.nvl(params.get("type")).equals("preInstallation") ? "/file/fileDown.do" : "/file/fileDownWasMobile.do";
    if(CommonUtils.nvl(params.get("type")).equals("preInstallation"))
      type = "/file/fileDown.do";
    else if(fileType.equals("web"))
      type = "/file/fileDownWeb.do";
    else
      type = "/file/fileDownWasMobile.do";

    model.addAttribute("type", type);
    model.addAttribute("imgLst", imgLst);
    model.addAttribute("path", uploadDir);

    return "sales/order/instImgViewerPop";
  }

  @RequestMapping(value = "/getHsImg.do")
  public String getHsImg(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO)
      throws Exception {

	    logger.debug("======================================================");
	    logger.debug("= PARAMS : " + params.toString());
	    logger.debug("======================================================");

    // GET IMAGE PATH
    List<EgovMap> imgLst = orderDetailService.getHsImg(params);
    logger.info("[OrderDetailController - getHsImg] imgLst :: {} " + imgLst);

    //String serialized = gson.toJson(imgLst);
    //JsonArray convertedArray = new Gson().fromJson(serialized, JsonArray.class);
    model.addAttribute("imgLst", imgLst);
    //model.addAttribute("imgLstArr", convertedArray);
    model.addAttribute("path", uploadDir);

    return "sales/order/hsImgViewerPop";
  }

  @RequestMapping(value = "/selectGSTRebateList.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectGSTRebateList(@RequestParam Map<String, Object> params, ModelMap model) {

    logger.debug("!@##############################################################################");
    logger.debug("!@###### salesOrderId : " + params.get("salesOrderId"));
    logger.debug("!@##############################################################################");

    List<EgovMap> memInfoList = orderDetailService.selectGSTRebateList(params);

    // 데이터 리턴.
    return ResponseEntity.ok(memInfoList);
  }

  @RequestMapping(value = "/getInstAsPSI.do")
  public String getInstAsPSI(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO)
      throws Exception {

    model.addAttribute("ordNo", params.get("ordNo"));

    return "sales/order/instAsPSIViewerPop";
  }

  @RequestMapping(value = "/getInstAsPSIData.do")
  public ResponseEntity<List<EgovMap>> getInstAsPSIData(@RequestParam Map<String, Object> params, ModelMap model) {
    logger.debug("===========================================>");
    logger.debug("params : {}", params);
    logger.debug("===========================================>");
    List<EgovMap> instAsPSIDt = orderDetailService.getInstAsPSIData(params);
    return ResponseEntity.ok(instAsPSIDt);
  }

  @RequestMapping(value = "/selectMCORemarkList.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectMCORemarkList(@RequestParam Map<String, Object> params, ModelMap model) {

    logger.debug("!@##############################################################################");
    logger.debug("!@###### salesOrderId : " + params.get("salesOrderId"));
    logger.debug("!@##############################################################################");

    List<EgovMap> mcoRemarkList = orderDetailService.selectMCORemarkList(params);

    // 데이터 리턴.
    return ResponseEntity.ok(mcoRemarkList);
  }

  @RequestMapping(value = "/selectFmcoEvoucherList.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectFmcoEvoucherList(@RequestParam Map<String, Object> params, ModelMap model) {

    logger.debug("!@##############################################################################");
    logger.debug("!@###### salesOrderId : " + params.get("salesOrderId"));
    logger.debug("!@##############################################################################");

    List<EgovMap> fmcoEvoucherList = orderDetailService.selectFmcoEvoucherList(params);

    // 데이터 리턴.
    return ResponseEntity.ok(fmcoEvoucherList);
  }
  
  @RequestMapping(value = "/selectPvRebateList.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectPvRebateList(@RequestParam Map<String, Object> params, ModelMap model) {

    logger.debug("!@##############################################################################");
    logger.debug("!@###### salesOrderId : " + params.get("salesOrderId"));
    logger.debug("!@##############################################################################");

    List<EgovMap> pvRebateList = orderDetailService.selectPvRebateList(params);

    // 데이터 리턴.
    return ResponseEntity.ok(pvRebateList);
  }

}
