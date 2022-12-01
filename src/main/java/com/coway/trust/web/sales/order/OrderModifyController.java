/**
 *
 */
package com.coway.trust.web.sales.order;

import java.text.ParseException;
import java.util.List;
import java.util.Map;
import java.util.ArrayList;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.AppConstants;
import com.coway.trust.api.callcenter.common.FileDto;
import com.coway.trust.biz.common.FileService;
import com.coway.trust.biz.common.FileVO;
import com.coway.trust.biz.sales.customer.CustomerService;
import com.coway.trust.biz.sales.order.OrderDetailService;
import com.coway.trust.biz.sales.order.OrderModifyService;
import com.coway.trust.biz.sales.order.OrderRegisterService;
import com.coway.trust.biz.sales.order.impl.OrderModifyMapper;
import com.coway.trust.biz.sales.order.vo.GSTEURCertificateVO;
import com.coway.trust.biz.sales.order.vo.OrderModifyVO;
import com.coway.trust.biz.sales.order.vo.OrderVO;
import com.coway.trust.biz.sales.order.vo.SalesOrderMVO;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.web.sales.SalesConstants;
import java.math.BigDecimal;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.ApiParam;

/**
 * @author Yunseok_Jang
 *
 */
@Controller
@RequestMapping(value = "/sales/order")
public class OrderModifyController {

  private static Logger logger = LoggerFactory.getLogger(OrderModifyController.class);

  @Resource(name = "orderDetailService")
  private OrderDetailService orderDetailService;

  @Resource(name = "orderModifyService")
  private OrderModifyService orderModifyService;

  @Resource(name = "orderRegisterService")
  private OrderRegisterService orderRegisterService;

  @Resource(name = "customerService")
  private CustomerService customerService;

  @Resource(name = "orderModifyMapper")
  private OrderModifyMapper orderModifyMapper;

  @Autowired
  private FileService fileService;

  @Autowired
  private MessageSourceAccessor messageAccessor;

  @RequestMapping(value = "/orderModifyPop.do")
  public String orderModifyPop(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO)
      throws Exception {

    String callCenterYn = "N";

    if (CommonUtils.isNotEmpty(params.get(AppConstants.CALLCENTER_TOKEN_KEY))) {
      callCenterYn = "Y";
    }

    // [Tap]Basic Info
    EgovMap orderDetail = orderDetailService.selectOrderBasicInfo(params, sessionVO);// APP_TYPE_ID
                                                                                     // CUST_ID
    EgovMap basicInfo = (EgovMap) orderDetail.get("basicInfo");

    model.put("orderDetail", orderDetail);
    model.put("salesOrderId", params.get("salesOrderId"));
    model.put("ordEditType", params.get("ordEditType"));
    model.put("custId", basicInfo.get("custId"));
    model.put("appTypeId", basicInfo.get("appTypeId"));
    model.put("appTypeDesc", basicInfo.get("appTypeDesc"));
    model.put("salesOrderNo", basicInfo.get("ordNo"));
    model.put("custNric", basicInfo.get("custNric"));
    model.put("ordStusId", basicInfo.get("ordStusId"));
    model.put("toDay", CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT1));
    model.put("promoCode", basicInfo.get("ordPromoCode"));
    model.put("promoDesc", basicInfo.get("ordPromoDesc"));
    model.put("srvPacId", basicInfo.get("srvPacId"));
    model.put("callCenterYn", callCenterYn);
    model.put("memType", sessionVO.getUserTypeId());
    model.put("ordPvMonth", basicInfo.get("ordPvMonth"));
    model.put("ordPvYear", basicInfo.get("ordPvYear"));
    model.put("typeId", basicInfo.get("typeId"));
    model.put("eKeyinYn", !CommonUtils.nvl(basicInfo.get("ekeyCrtUser")).equals("") ? "Y" : "N");

    logger.debug("!@##############################################################################");
    logger.debug("!@###### salesOrderId : " + model.get("salesOrderId"));
    logger.debug("!@###### ordEditType  : " + model.get("ordEditType"));
    logger.debug("!@###### custId       : " + model.get("custId"));
    logger.debug("!@###### appTypeId    : " + model.get("appTypeId"));
    logger.debug("!@###### appTypeDesc  : " + model.get("appTypeDesc"));
    logger.debug("!@###### salesOrderNo : " + model.get("salesOrderNo"));
    logger.debug("!@###### custNric     : " + model.get("custNric"));
    logger.debug("!@##############################################################################");

    return "sales/order/orderModifyPop";
  }

  @RequestMapping(value = "/updateOrderBasinInfo.do", method = RequestMethod.POST)
  public ResponseEntity<ReturnMessage> updateOrderBasinInfo(@RequestBody Map<String, Object> params, ModelMap model,
      SessionVO sessionVO) {

    orderModifyService.updateOrderBasinInfo(params, sessionVO);

    // 결과 만들기
    ReturnMessage message = new ReturnMessage();
    message.setCode(AppConstants.SUCCESS);
    // message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
    message.setMessage("Order Number : " + params.get("salesOrdNo") + "</br>Information successfully updated.");

    return ResponseEntity.ok(message);
  }

  @RequestMapping(value = "/updateMailingAddress.do", method = RequestMethod.POST)
  public ResponseEntity<ReturnMessage> updateMailingAddress(@RequestBody Map<String, Object> params, ModelMap model,
      SessionVO sessionVO) throws ParseException {

    orderModifyService.updateOrderMailingAddress(params, sessionVO);

    // 결과 만들기
    ReturnMessage message = new ReturnMessage();
    message.setCode(AppConstants.SUCCESS);
    // message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
    message.setMessage("Mailing address has been updated.");

    return ResponseEntity.ok(message);
  }

  @RequestMapping(value = "/updateMailingAddress2.do", method = RequestMethod.POST)
  public ResponseEntity<ReturnMessage> updateMailingAddress2(@RequestBody Map<String, Object> params, ModelMap model,
      SessionVO sessionVO) throws ParseException {

    orderModifyService.updateOrderMailingAddress2(params, sessionVO);

    // 결과 만들기
    ReturnMessage message = new ReturnMessage();
    message.setCode(AppConstants.SUCCESS);
    // message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
    message.setMessage("Information successfully updated.");

    return ResponseEntity.ok(message);
  }

  @RequestMapping(value = "/updateCntcPerson.do", method = RequestMethod.POST)
  public ResponseEntity<ReturnMessage> updateCntcPerson(@RequestBody Map<String, Object> params, ModelMap model,
      SessionVO sessionVO) throws ParseException {

    orderModifyService.updateCntcPerson(params, sessionVO);

    // 결과 만들기
    ReturnMessage message = new ReturnMessage();
    message.setCode(AppConstants.SUCCESS);
    // message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
    message.setMessage("Contact person has been updated.");

    return ResponseEntity.ok(message);
  }

  @RequestMapping(value = "/updateNric.do", method = RequestMethod.POST)
  public ResponseEntity<ReturnMessage> updateNric(@RequestBody Map<String, Object> params, ModelMap model,
      SessionVO sessionVO) throws ParseException {

    orderModifyService.updateNric(params, sessionVO);

    // 결과 만들기
    ReturnMessage message = new ReturnMessage();
    message.setCode(AppConstants.SUCCESS);
    // message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
    message.setMessage("NRIC has been successfully updated.");

    return ResponseEntity.ok(message);
  }

  @RequestMapping(value = "/updatePaymentChannel.do", method = RequestMethod.POST)
  public ResponseEntity<ReturnMessage> updatePaymentChannel(@RequestBody Map<String, Object> params, ModelMap model,
      SessionVO sessionVO) throws Exception {

    orderModifyService.updatePaymentChannel(params, sessionVO);

	params.put("ordId", params.get("salesOrdId"));
	EgovMap checkFraInsRtnMsg = orderModifyMapper.getInstallDetail(params);

		//passed from OrderMgmt(HC) but only update mattress
    	if( (checkFraInsRtnMsg.get("modeId").toString().equals(params.get("rentPayMode").toString())) && (Integer.parseInt( (String) params.get("hasFrame")) == 2) ){

    			   ReturnMessage message = new ReturnMessage();
    			   message.setCode(AppConstants.SUCCESS);

    			   // message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
    			   message.setMessage("Information Successfully Updated.");

    			   return ResponseEntity.ok(message);

    		//passed from OrderMgmt(HC) and both updated
    		}else if((checkFraInsRtnMsg.get("modeId").toString().equals(params.get("rentPayMode").toString())) && (Integer.parseInt( (String) params.get("hasFrame")) == 3) ){
    			    ReturnMessage message = new ReturnMessage();
    			    message.setCode(AppConstants.SUCCESS);

    			    // message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
    			    message.setMessage("Mattress And Frame Order "  + "</br>Information successfully updated.");

    			    return ResponseEntity.ok(message);
    		}else{
    		//passed from Order Mgmt

        // 결과 만들기
                    ReturnMessage message = new ReturnMessage();
                    message.setCode(AppConstants.SUCCESS);

                    // message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
                    message.setMessage("Order Number : " + params.get("salesOrdNo") + "</br>Information successfully updated.");

                    return ResponseEntity.ok(message);
                  }
  }
  @RequestMapping(value = "/saveDocSubmission.do", method = RequestMethod.POST)
  public ResponseEntity<ReturnMessage> saveDocSubmission(@RequestBody OrderVO orderVO, HttpServletRequest request,
      Model model, SessionVO sessionVO) throws Exception {

    orderModifyService.saveDocSubmission(orderVO, sessionVO);

    // 결과 만들기
    ReturnMessage message = new ReturnMessage();
    message.setCode(AppConstants.SUCCESS);
    // message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
    message.setMessage("Order document submission information successfully updated.");

    return ResponseEntity.ok(message);
  }

  @RequestMapping(value = "/selectBillGrpMailingAddrJson.do", method = RequestMethod.GET)
  public ResponseEntity<EgovMap> selectBillGrpMailingAddrJson(@RequestParam Map<String, Object> params, ModelMap model)
      throws Exception {

    logger.debug("!@##############################################################################");
    logger.debug("!@###### salesOrderId : " + params.get("salesOrderId"));
    logger.debug("!@##############################################################################");

    EgovMap resultMap = orderModifyService.selectBillGrpMailingAddr(params);

    // 데이터 리턴.
    return ResponseEntity.ok(resultMap);
  }

  @RequestMapping(value = "/selectBillGrpCntcPersonJson.do", method = RequestMethod.GET)
  public ResponseEntity<EgovMap> selectBillGrpCntcPerson(@RequestParam Map<String, Object> params, ModelMap model)
      throws Exception {

    logger.debug("!@##############################################################################");
    logger.debug("!@###### salesOrderId : " + params.get("salesOrderId"));
    logger.debug("!@##############################################################################");

    EgovMap resultMap = orderModifyService.selectBillGrpCntcPerson(params);

    // 데이터 리턴.
    return ResponseEntity.ok(resultMap);
  }

  @RequestMapping(value = "/checkNricEdit.do", method = RequestMethod.GET)
  public ResponseEntity<EgovMap> checkNricEdit(@RequestParam Map<String, Object> params, ModelMap model)
      throws Exception {

    logger.debug("!@##############################################################################");
    logger.debug("!@###### salesOrderId : " + params.get("salesOrderId"));
    logger.debug("!@##############################################################################");

    EgovMap resultMap = orderModifyService.checkNricEdit(params);

    // 데이터 리턴.
    return ResponseEntity.ok(resultMap);
  }

  @RequestMapping(value = "/checkNricExist.do", method = RequestMethod.GET)
  public ResponseEntity<EgovMap> checkNricExist(@RequestParam Map<String, Object> params, ModelMap model)
      throws Exception {

    logger.debug("!@##############################################################################");
    logger.debug("!@###### salesOrderId : " + params.get("salesOrderId"));
    logger.debug("!@##############################################################################");

    EgovMap resultMap = orderModifyService.checkNricExist(params);

    logger.info("resultMap:" + resultMap);

    // 데이터 리턴.
    return ResponseEntity.ok(resultMap);
  }

  @RequestMapping(value = "/selectCustomerInfo.do", method = RequestMethod.GET)
  public ResponseEntity<EgovMap> selectCustomerInfo(@RequestParam Map<String, Object> params, ModelMap model)
      throws Exception {

    EgovMap resultMap = orderModifyService.selectCustomerInfo(params);

    // 데이터 리턴.
    return ResponseEntity.ok(resultMap);
  }

  @RequestMapping(value = "/selectInstallInfo.do", method = RequestMethod.GET)
  public ResponseEntity<EgovMap> selectInstallInfo(@RequestParam Map<String, Object> params, ModelMap model)
      throws Exception {

    EgovMap resultMap = orderModifyService.selectInstallInfo(params);

    // 데이터 리턴.
    return ResponseEntity.ok(resultMap);
  }

  @RequestMapping(value = "/selectInstallAddrInfo.do", method = RequestMethod.GET)
  public ResponseEntity<EgovMap> selectInstallAddrInfo(@RequestParam Map<String, Object> params, ModelMap model)
      throws Exception {

    EgovMap resultMap = orderModifyService.selectInstallAddrInfo(params);

    // 데이터 리턴.
    return ResponseEntity.ok(resultMap);
  }

  @RequestMapping(value = "/selectInstallCntcInfo.do", method = RequestMethod.GET)
  public ResponseEntity<EgovMap> selectInstallCntcInfo(@RequestParam Map<String, Object> params, ModelMap model)
      throws Exception {

    EgovMap resultMap = orderModifyService.selectInstallCntcInfo(params);

    // 데이터 리턴.
    return ResponseEntity.ok(resultMap);
  }

  @RequestMapping(value = "/selectInstRsltCount.do", method = RequestMethod.GET)
  public ResponseEntity<EgovMap> selectInstRsltCount(@RequestParam Map<String, Object> params, ModelMap model)
      throws Exception {

    EgovMap resultMap = orderModifyService.selectInstRsltCount(params);

    // 데이터 리턴.
    return ResponseEntity.ok(resultMap);
  }

  @RequestMapping(value = "/selectGSTZRLocationCount.do", method = RequestMethod.GET)
  public ResponseEntity<EgovMap> selectGSTZRLocationCount(@RequestParam Map<String, Object> params, ModelMap model)
      throws Exception {

    EgovMap resultMap = orderModifyService.selectGSTZRLocationCount(params);

    // 데이터 리턴.
    return ResponseEntity.ok(resultMap);
  }

  @RequestMapping(value = "/selectGSTZRLocationByAddrIdCount.do", method = RequestMethod.GET)
  public ResponseEntity<EgovMap> selectGSTZRLocationByAddrIdCount(@RequestParam Map<String, Object> params,
      ModelMap model) throws Exception {

    EgovMap resultMap = orderModifyService.selectGSTZRLocationByAddrIdCount(params);

    // 데이터 리턴.
    return ResponseEntity.ok(resultMap);
  }

  @RequestMapping(value = "/updateInstallInfo.do", method = RequestMethod.POST)
  public ResponseEntity<ReturnMessage> updateInstallInfo(@RequestBody Map<String, Object> params, ModelMap model,
      SessionVO sessionVO) throws ParseException {

    orderModifyService.updateInstallInfo(params, sessionVO);

    // 결과 만들기
    ReturnMessage message = new ReturnMessage();
    message.setCode(AppConstants.SUCCESS);
    // message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
    message.setMessage("Order Number : " + params.get("salesOrdNo") + "<br />Information successfully updated.");

    return ResponseEntity.ok(message);
  }

  @RequestMapping(value = "/selectRentPaySetInfo.do", method = RequestMethod.GET)
  public ResponseEntity<EgovMap> selectRentPaySetInfo(@RequestParam Map<String, Object> params, ModelMap model)
      throws Exception {

    EgovMap resultMap = orderModifyService.selectRentPaySetInfo(params);

    // 데이터 리턴.
    return ResponseEntity.ok(resultMap);
  }

  @RequestMapping(value = "/selectCustomerBankDetailView.do", method = RequestMethod.GET)
  public ResponseEntity<EgovMap> selectCustomerBankDetailView(@RequestParam Map<String, Object> params, ModelMap model)
      throws Exception {

    EgovMap resultMap = customerService.selectCustomerBankDetailViewPop(params);

    // 데이터 리턴.
    return ResponseEntity.ok(resultMap);
  }

  @RequestMapping(value = "/selectCustomerCreditCardDetailView.do", method = RequestMethod.GET)
  public ResponseEntity<EgovMap> selectCustomerCreditCardDetailView(@RequestParam Map<String, Object> params,
      ModelMap model) throws Exception {

    EgovMap resultMap = customerService.selectCustomerCreditCardDetailViewPop(params);

    resultMap.put("decryptCRCNoShow",
        CommonUtils.getMaskCreditCardNo(StringUtils.trim((String) resultMap.get("custOriCrcNo")), "*", 4));

    // 데이터 리턴.
    return ResponseEntity.ok(resultMap);
  }

  @RequestMapping(value = "/selectEditDocSubmList.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectEditDocSubmList(@RequestParam Map<String, Object> params, ModelMap model) {

    logger.debug("!@##############################################################################");
    logger.debug("!@###### /selectEditDocSubmList.do : salesOrderId : " + params.get("salesOrderId"));
    logger.debug("!@##############################################################################");

    List<EgovMap> docuList = orderRegisterService.selectDocSubmissionList(params);
    List<EgovMap> saveList = orderDetailService.selectDocumentList(params);

    int chkfield = 0;
    BigDecimal docCopyQty = BigDecimal.ZERO;
    BigDecimal codeId = BigDecimal.ZERO;
    BigDecimal docTypeId = BigDecimal.ZERO;

    List<EgovMap> mapList = new ArrayList<EgovMap>();

    for (EgovMap docuMap : docuList) {

      chkfield = 0;
      docCopyQty = BigDecimal.ZERO;
      codeId = (BigDecimal) docuMap.get("codeId");

      for (EgovMap saveMap : saveList) {

        docTypeId = (BigDecimal) saveMap.get("docTypeId");

        if (codeId.compareTo(docTypeId) == 0) {
          chkfield = 1;
          docCopyQty = (BigDecimal) saveMap.get("docCopyQty");

          break;
        }
      }

      docuMap.put("chkfield", chkfield);
      docuMap.put("docCopyQty", docCopyQty);
      docuMap.put("docTypeId", codeId);
      docuMap.put("docSoId", params.get("salesOrderId"));

      mapList.add(docuMap);
    }

    // 데이터 리턴.
    return ResponseEntity.ok(mapList);
  }

  @RequestMapping(value = "/selectReferralList.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectReferralList(@RequestParam Map<String, Object> params) {
    List<EgovMap> rsltList = orderModifyService.selectReferralList(params);
    return ResponseEntity.ok(rsltList);
  }

  @RequestMapping(value = "/selectStateCodeList.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectStateCodeList(@RequestParam Map<String, Object> params) {
    List<EgovMap> rsltList = orderModifyService.selectStateCodeList(params);
    return ResponseEntity.ok(rsltList);
  }

  @RequestMapping(value = "/saveReferral.do", method = RequestMethod.POST)
  public ResponseEntity<ReturnMessage> saveReferral(@RequestBody OrderModifyVO orderModifyVO,
      HttpServletRequest request, Model model, SessionVO sessionVO) throws Exception {

    orderModifyService.saveReferral(orderModifyVO, sessionVO);

    // 결과 만들기
    ReturnMessage message = new ReturnMessage();
    message.setCode(AppConstants.SUCCESS);
    // message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
    message.setMessage(messageAccessor.getMessage("Inactive Referral successfully saved."));

    return ResponseEntity.ok(message);
  }

  @RequestMapping(value = "/updatePromoPriceInfo.do", method = RequestMethod.POST)
  public ResponseEntity<ReturnMessage> updatePromoPriceInfo(@RequestBody SalesOrderMVO salesOrderMVO,
      HttpServletRequest request, Model model, SessionVO sessionVO) throws Exception {

    orderModifyService.updatePromoPriceInfo(salesOrderMVO, sessionVO);

    // 결과 만들기
    ReturnMessage message = new ReturnMessage();
    message.setCode(AppConstants.SUCCESS);
    // message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
    message.setMessage("Order Number : " + salesOrderMVO.getSalesOrdNo() + "<br />Information successfully updated.");

    return ResponseEntity.ok(message);
  }

  @RequestMapping(value = "/updateGstCertInfo.do", method = RequestMethod.POST)
  public ResponseEntity<ReturnMessage> updateGstCertInfo(@RequestBody GSTEURCertificateVO gSTEURCertificateVO,
      HttpServletRequest request, Model model, SessionVO sessionVO) throws Exception {

    orderModifyService.updateGSTEURCertificate(gSTEURCertificateVO, sessionVO);

    // 결과 만들기
    ReturnMessage message = new ReturnMessage();
    message.setCode(AppConstants.SUCCESS);
    // message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
    message.setMessage("GST certificate saved.");

    return ResponseEntity.ok(message);
  }

  @RequestMapping(value = "/selectGSTCertInfo.do", method = RequestMethod.GET)
  public ResponseEntity<EgovMap> selectGSTCertInfo(@RequestParam Map<String, Object> params) {
    EgovMap rslt = orderDetailService.selectGSTCertInfo(params);
    return ResponseEntity.ok(rslt);
  }

  @RequestMapping(value = "/gstCertFileDown.do", method = RequestMethod.GET)
  public ResponseEntity<FileDto> getFilesByGroupId(@RequestParam Map<String, Object> params) throws Exception {
    int fileGroupId = Integer.parseInt((String) params.get("atchFileGrpId"));

    List<FileVO> list = fileService.getFiles(fileGroupId);
    FileDto fileDto = FileDto.createByFileVO(list, fileGroupId);
    return ResponseEntity.ok(fileDto);
  }

  @RequestMapping(value = "/getInstallDetail.do", method = RequestMethod.GET)
  public ResponseEntity<EgovMap> getInstallDetail(@RequestParam Map<String, Object> params, ModelMap model,
      HttpServletRequest request) {
    EgovMap orderInstallDetail = orderModifyService.getInstallDetail(params);
    logger.debug("orderInstallDetail : {}", orderInstallDetail);
    return ResponseEntity.ok(orderInstallDetail);
  }

  @RequestMapping(value = "/updateCcpOrderBasinInfo.do", method = RequestMethod.POST)
  public ResponseEntity<ReturnMessage> updateCcpOrderBasinInfo(@RequestBody Map<String, Object> params, ModelMap model,
      SessionVO sessionVO) {

    orderModifyService.updateCcpOrderBasinInfo(params, sessionVO);

    // 결과 만들기
    ReturnMessage message = new ReturnMessage();
    message.setCode(AppConstants.SUCCESS);
    // message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
    message.setMessage("Order Number : " + params.get("salesOrdNo") + "</br>Information successfully updated.");

    return ResponseEntity.ok(message);
  }

  @RequestMapping(value = "/chkCboPromPck.do", method = RequestMethod.GET)
  public ResponseEntity<Integer> chkCboPromPck(@RequestParam Map<String, Object> params) {
    int rslt = orderModifyService.chkCboPromPck(params);
    return ResponseEntity.ok(rslt);
  }

  @RequestMapping(value = "/getExistSofNo.do")
	public ResponseEntity<EgovMap> getExistSofNo(@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model) {
	  logger.debug("SOFNo : {}"  + params.get("ordRefNo"));
		int cnt = orderModifyService.getExistSofNo(params);

		EgovMap result = new EgovMap();

		result.put("IS_EXIST", cnt > 0 ? "true" : "false");

		return ResponseEntity.ok(result);
	}

  @RequestMapping(value = "/saveMcoRem.do", method = RequestMethod.POST)
  public ResponseEntity<ReturnMessage> saveMcoRem(@RequestBody Map<String, Object> params, ModelMap mode, SessionVO sessionVO) {

      logger.debug("saveMcoRem");
      logger.debug("params {}", params);

      params.put("userId", sessionVO.getUserId());

      orderModifyService.updateMcoRem(params);

      ReturnMessage message = new ReturnMessage();
      message.setCode(AppConstants.SUCCESS);

      return ResponseEntity.ok(message);
  }
}
