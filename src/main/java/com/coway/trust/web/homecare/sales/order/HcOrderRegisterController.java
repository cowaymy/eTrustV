package com.coway.trust.web.homecare.sales.order;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.common.CommonService;
import com.coway.trust.biz.homecare.sales.order.HcOrderListService;
import com.coway.trust.biz.homecare.sales.order.HcOrderRegisterService;
import com.coway.trust.biz.homecare.sales.order.HcOrderRequestService;
import com.coway.trust.biz.homecare.sales.order.vo.HcOrderVO;
import com.coway.trust.biz.sales.order.OrderDetailService;
import com.coway.trust.biz.sales.order.OrderRegisterService;
import com.coway.trust.biz.sales.order.PreOrderService;
import com.coway.trust.biz.sales.order.vo.OrderVO;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.web.homecare.HomecareConstants;
import com.coway.trust.web.sales.SalesConstants;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : HcOrderRegisterController.java
 * @Description : TO-DO Class Description
 *
 * @History
 *
 *          <pre>
 * Date            Author       Description
 * -------------  -----------  -------------
 * 2019. 10. 17.   KR-SH        First creation
 *          </pre>
 */
@Controller
@RequestMapping(value = "/homecare/sales/order")
public class HcOrderRegisterController {

  private static Logger logger = LoggerFactory.getLogger(HcOrderRegisterController.class);

	@Resource(name = "hcOrderRegisterService")
	private HcOrderRegisterService hcOrderRegisterService;

	@Resource(name = "orderDetailService")
	private OrderDetailService orderDetailService;

	@Resource(name = "hcOrderListService")
	private HcOrderListService hcOrderListService;

	@Resource(name = "commonService")
	private CommonService commonService;

  @Resource(name = "preOrderService")
  private PreOrderService preOrderService;

    @Resource(name = "orderRegisterService")
  	private OrderRegisterService orderRegisterService;

    @Resource(name = "hcOrderRequestService")
	private HcOrderRequestService hcOrderRequestService;

	@Autowired
	private MessageSourceAccessor messageAccessor;

	/**
	 * New Order Popup
	 *
	 * @Author KR-SH
	 * @Date 2019. 10. 17.
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/hcOrderRegisterPop.do")
	public String main(@RequestParam Map<String, Object> params, ModelMap model) {
		// code List
        params.clear();
        params.put("groupCode", 10);
        params.put("orderValue", "CODE_ID");
        List<EgovMap> codeList_10 = commonService.selectCodeList(params);

        params.put("groupCode", 19);
        params.put("orderValue", "CODE_NAME");
        List<EgovMap> codeList_19 = commonService.selectCodeList(params);

        params.put("groupCode", 17);
        params.put("orderValue", "CODE_NAME");
        List<EgovMap> codeList_17 = commonService.selectCodeList(params);

        params.put("groupCode", 322);
        params.put("orderValue", "CODE_ID");
        List<EgovMap> codeList_322 = commonService.selectCodeList(params);


        EgovMap checkExtradeSchedule = preOrderService.checkExtradeSchedule();

        String dayFrom = "", dayTo = "";

        if(checkExtradeSchedule!=null){
        	dayFrom = checkExtradeSchedule.get("startDate").toString();
        	dayTo = checkExtradeSchedule.get("endDate").toString();
        }
        else{
        	dayFrom = "20"; // default 20-{month-1}
       		dayTo = "31"; // default LAST DAY OF THE MONTH
        }

    	String bfDay = CommonUtils.changeFormat(CommonUtils.getCalMonth(-1), SalesConstants.DEFAULT_DATE_FORMAT3,
    				SalesConstants.DEFAULT_DATE_FORMAT1);
    	String toDay = CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT1);

    	model.put("hsBlockDtFrom", dayFrom);
    	model.put("hsBlockDtTo", dayTo);

    	model.put("bfDay", bfDay);
    	model.put("toDay", toDay);

      model.put("codeList_10", codeList_10);
      model.put("codeList_17", codeList_17);
      model.put("codeList_19", codeList_19);
      model.put("codeList_322", codeList_322);
      model.put("codeList_562", commonService.selectCodeList("562", "CODE_NAME"));
		  model.put("toDay", CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT1));

		return "homecare/sales/order/hcOrderRegisterPop";
	}

	/**
	 * Salese Order - select Product List(Homacare)
	 *
	 * @Author KR-SH
	 * @Date 2019. 10. 18.
	 * @param params
	 * @return
	 */
	@RequestMapping(value = "/selectHcProductCodeList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectProductCodeList(@RequestParam Map<String, Object> params) {
		// Homecare Product List
		List<EgovMap> codeList = hcOrderRegisterService.selectHcProductCodeList(params);

		return ResponseEntity.ok(codeList);
	}

	/**
	 * Homecare Order Confirm Popup
	 *
	 * @Author KR-SH
	 * @Date 2019. 10. 22.
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/hcCnfmOrderDetailPop.do")
	public String hcCnfmOrderDetailPop(@RequestParam Map<String, Object> params, ModelMap model) {
		return "homecare/sales/order/hcCnfmOrderDetailPop";
	}

	@RequestMapping(value = "/hcOrderComboSearchPop.do")
  public String hcOrderComboSearchPop(@RequestParam Map<String, Object> params, ModelMap model) {
    model.put("promoNo", params.get("promoNo"));
    model.put("prod", params.get("prod"));
    model.put("custId", params.get("custId"));
    if (params.get("ord_id") != null) {
      model.put("ordId", params.get("ord_id"));
    } else {
      model.put("ordId", "");
    }

    return "homecare/sales/order/hcOrderComboSearchPop";
  }

  @RequestMapping(value = "/chkPromoCboMst.do", method = RequestMethod.POST)
  public ResponseEntity<ReturnMessage> chkPromoCboMst(@RequestBody Map<String, Object> params, ModelMap model, SessionVO sessionVO) {
    ReturnMessage message = new ReturnMessage();

    logger.info("==================/chkPromoCboMst.do=======================");
    logger.info("[HcOrderRegisterController - chkPromoCboMst] params : {}", params);
    logger.info("==================/chkPromoCboMst.do=======================");

    int statCode = hcOrderRegisterService.chkPromoCboMst(params);

    if (statCode == 1) {
      message.setMessage("NORMAL PROMOTION[NOT COMBO]");
    } else if (statCode == 2) {
      message.setMessage("IS MASTER COMBO PACKAGE");
    } else if (statCode == 3) {
      message.setMessage("HAVE MASTER COMBO ORDER TO MAP");
    } else if (statCode == 4) {
      message.setMessage("PLEASE CREATE A MASTER COMBO TO MAP");
    }

    message.setCode(Integer.toString(statCode));
    return ResponseEntity.ok(message);
  }

  @RequestMapping(value = "/selectHcAcComboOrderJsonList", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectHcAcComboOrderJsonList(@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model) {

    logger.debug("==================/selectHcAcComboOrderJsonList.do=======================");
    logger.debug("[HcOrderRegisterController - selectHcAcComboOrderJsonList] params : {}", params);
    logger.debug("==================/selectHcAcComboOrderJsonList.do=======================");

    List<EgovMap> orderList = hcOrderRegisterService.selectHcAcComboOrderJsonList(params);

    return ResponseEntity.ok(orderList);
  }

  @RequestMapping(value = "/selectHcAcComboOrderJsonList_2", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectHcAcComboOrderJsonList_2(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model) {

    logger.debug("==================/selectHcAcComboOrderJsonList_2.do=======================");
    logger.debug("[HcOrderRegisterController - selectHcAcComboOrderJsonList_2]  params : {}", params);
    logger.debug("==================/selectHcAcComboOrderJsonList_2.do=======================");

    List<EgovMap> orderList = hcOrderRegisterService.selectHcAcComboOrderJsonList_2(params);

    return ResponseEntity.ok(orderList);
  }

  @RequestMapping(value = "/chkIsMaxCmbOrd.do", method = RequestMethod.POST)
  public ResponseEntity<ReturnMessage> chkIsMaxCmbOrd(@RequestBody Map<String, Object> params, ModelMap model, SessionVO sessionVO) {

    ReturnMessage message = new ReturnMessage();

    logger.debug("==================/chkIsMaxCmbOrd=======================");
    logger.debug("[HcOrderRegisterController - chkIsMaxCmbOrd] params : {}", params);
    logger.debug("==================/chkIsMaxCmbOrd=======================");

    int qtyCmbOrd =  hcOrderRegisterService.chkQtyCmbOrd(params);
    logger.info("[HcOrderRegisterController - chkIsMaxCmbOrd] qtyCmbOrd :: " + qtyCmbOrd );

    message.setCode(Integer.toString(qtyCmbOrd));
    return ResponseEntity.ok(message);
  }

  @RequestMapping(value = "/selectHcAcCmbOrderDtlList", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectHcAcCmbOrderDtlList(@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model) {

    logger.debug("==================/selectHcAcCmbOrderDtlList.do=======================");
    logger.debug("[HcOrderRegisterController - selectHcAcCmbOrderDtlList] params : {}", params);
    logger.debug("==================/selectHcAcCmbOrderDtlList.do=======================");

    List<EgovMap> orderList = hcOrderRegisterService.selectHcAcCmbOrderDtlList(params);

    return ResponseEntity.ok(orderList);
  }

	/**
	 * Homecare Register Order
	 *
	 * @Author KR-SH
	 * @Date 2019. 10. 23.
	 * @param orderVO
	 * @param request
	 * @param model
	 * @param sessionVO
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/hcRegisterOrder.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> hcRegisterOrder(@RequestBody OrderVO orderVO, SessionVO sessionVO) throws Exception {
		String appTypeName = HomecareConstants.cnvAppTypeName(orderVO.getSalesOrderMVO1().getAppTypeId());
		// Register Homecare Order
		hcOrderRegisterService.hcRegisterOrder(orderVO, sessionVO);

		//String isExtradePR = orderVO.getSalesOrderMVO().getIsExtradePR().toString();
		String isExtradePR = CommonUtils.isEmpty(orderVO.getSalesOrderMVO1().getIsExtradePR()) == true ? "" : orderVO.getSalesOrderMVO1().getIsExtradePR().toString();

		// Ex-Trade : 1
    	if (isExtradePR.equals("1") && CommonUtils.isNotEmpty(orderVO.getSalesOrderMVO1().getBindingNo())
    			) {
    		//logger.debug("@#### Order Cancel START");
    		String nowDate = "";
    		Date date = new Date();
            SimpleDateFormat df = new SimpleDateFormat("dd/MM/yyyy", Locale.getDefault(Locale.Category.FORMAT));
            nowDate = df.format(date);

    		//logger.debug("@#### nowDate:" + nowDate);

    		Map<String, Object> cParam = new HashMap();
    		boolean isHc = String.valueOf(orderVO.getSalesOrderMVO1().getBusType()).equals("HOMECARE") ? true : false;

    		cParam.put("salesOrdNo", orderVO.getSalesOrderMVO1().getBindingNo());

    		EgovMap rMap = null;
    		if(isHc){
    			Map<String, Object> hcParam = new HashMap();
    			hcParam.put("ordNo", orderVO.getSalesOrderMVO1().getBindingNo());
    			rMap = hcOrderListService.selectHcOrderInfo(hcParam);
    			cParam.put("salesOrdId", String.valueOf(rMap.get("srvOrdId")));
    			cParam.put("salesAnoOrdId", String.valueOf(rMap.get("anoOrdId")));
    			cParam.put("salesOrdCtgryCd", String.valueOf(rMap.get("ordCtgryCd")));
    		}else{
    			rMap = orderRegisterService.selectOldOrderId(cParam);
    			cParam.put("salesOrdId", String.valueOf(rMap.get("salesOrdId")));
    		}

    //				cParam.put("salesOrdId", String.valueOf(rMap.get("salesOrdId")));
    //				cParam.put("salesAnoOrdId", String.valueOf(rMap.get("salesOrdId")));
    //				cParam.put("salesOrdCtgryCd", String.valueOf(rMap.get("salesOrdId")));
    		cParam.put("cmbRequestor", "527");
    		cParam.put("dpCallLogDate", nowDate);
    		cParam.put("cmbReason", "1993");
    		cParam.put("txtRemark", "Auto Cancellation for Ex-Trade");
    		cParam.put("txtTotalAmount", "0");
    		cParam.put("txtPenaltyCharge", "0");
    		cParam.put("txtObPeriod", "0");
    		cParam.put("txtCurrentOutstanding", "0");
    		cParam.put("txtTotalUseMth", "0");
    		cParam.put("txtPenaltyAdj", "0");

    		hcOrderRequestService.hcRequestCancelOrder(cParam, sessionVO);
    	}

		String msg = "";
		HcOrderVO hcOrderVO = orderVO.getHcOrderVO();

		msg += "Order successfully saved.<br />";

		if ("Y".equals(orderVO.getCopyOrderBulkYN())) {
			msg += "Order Number : " + orderVO.getSalesOrdNoFirst() + " ~ " + orderVO.getSalesOrderMVO().getSalesOrdNo()
					+ "<br />";
		} else {
			if(!"".equals(CommonUtils.nvl(hcOrderVO.getMatOrdNo()))) {
				msg += "Order Number(Mattres) : " + hcOrderVO.getMatOrdNo() + "<br />";
			}
			if(!"".equals(CommonUtils.nvl(hcOrderVO.getFraOrdNo()))) {
				msg += "Order Number(Frame) : "   + hcOrderVO.getFraOrdNo() + "<br />";
			}
		}

		if (orderVO.getSalesOrderDVO().getItmCompId() == 2 || orderVO.getSalesOrderDVO().getItmCompId() == 3
				|| orderVO.getSalesOrderDVO().getItmCompId() == 4) {
			msg += "AS Number : " + orderVO.getASEntryVO().getAsNo() + "<br />";
		}
		msg += "Bundle Number : " + hcOrderVO.getBndlNo() + "<br />";
		msg += "Application Type : " + appTypeName + "<br />";

		// 결과 만들기
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(msg);

		return ResponseEntity.ok(message);
	}

	/**
	 * Check Product Size
	 * @Author KR-SH
	 * @Date 2019. 12. 16.
	 * @param params
	 * @return
	 */
	@RequestMapping(value = "/checkProductSize.do")
	public ResponseEntity<ReturnMessage> checkProductSize(@RequestParam Map<String, Object> params) {
		boolean chkSize = hcOrderRegisterService.checkProductSize(params);

		// 결과 만들기
		ReturnMessage message = new ReturnMessage();
		if(chkSize) {
			message.setCode(AppConstants.SUCCESS);
			message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		} else {
			message.setCode(AppConstants.FAIL);
			message.setMessage("Product Size is different.");
		}

		return ResponseEntity.ok(message);
	}

	/**
	 * Select Promotion By Frame
	 * @Author KR-SH
	 * @Date 2019. 12. 24.
	 * @param params
	 * @return
	 */
	@RequestMapping(value = "/selectPromotionByFrame.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectPromotionByFrame(@RequestParam Map<String, Object> params) {
		List<EgovMap> codeList = hcOrderRegisterService.selectPromotionByFrame(params);
	    return ResponseEntity.ok(codeList);
	}

	/**
	 * Copy(change) Homecare Order
	 * @Author KR-SH
	 * @Date 2019. 12. 30.
	 * @param params
	 * @param model
	 * @param sessionVO
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/copyChangeHcOrder.do")
	public String copyChangeHcOrder(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) throws Exception {
		// 매핑테이블 조회. - HMC0011D
		EgovMap hcPreOrdInfo = hcOrderListService.selectHcOrderInfo(params);
		EgovMap matOrderInfo = null;
		EgovMap frmOrderInfo = null;
		String matOrdId = "";
		String fraOrdId =  "";
		String ordCtgryCd = CommonUtils.nvl(hcPreOrdInfo.get("ordCtgryCd")); // Homecare Category CD

		if(ordCtgryCd.equals(HomecareConstants.HC_CTGRY_CD.MAT) || ordCtgryCd.equals(HomecareConstants.HC_CTGRY_CD.ACI)) {
			matOrdId = CommonUtils.nvl(hcPreOrdInfo.get("ordId"));
			fraOrdId = CommonUtils.nvl(hcPreOrdInfo.get("anoOrdId"));
		} else {
			matOrdId = CommonUtils.nvl(hcPreOrdInfo.get("anoOrdId"));
			fraOrdId = CommonUtils.nvl(hcPreOrdInfo.get("ordId"));
		}

		if(!"".equals(matOrdId) && !"0".equals(matOrdId)) {
			// Mattress Order Info
			params.put("salesOrderId", matOrdId);
			matOrderInfo = orderDetailService.selectOrderBasicInfo(params, sessionVO);
		}
		if(!"".equals(fraOrdId) && !"0".equals(fraOrdId)) {
    		// Frame Order Info
    		params.put("salesOrderId", fraOrdId);
    		frmOrderInfo = orderDetailService.selectOrderBasicInfo(params, sessionVO);
		}

		// code List
        params.clear();
        params.put("groupCode", 10);
        params.put("orderValue", "CODE_ID");
        List<EgovMap> codeList_10 = commonService.selectCodeList(params);

        params.put("groupCode", 19);
        params.put("orderValue", "CODE_NAME");
        List<EgovMap> codeList_19 = commonService.selectCodeList(params);

        params.put("groupCode", 17);
        params.put("orderValue", "CODE_NAME");
        List<EgovMap> codeList_17 = commonService.selectCodeList(params);

        params.put("groupCode", 322);
        params.put("orderValue", "CODE_ID");
        List<EgovMap> codeList_322 = commonService.selectCodeList(params);

        model.put("codeList_10", codeList_10);
        model.put("codeList_17", codeList_17);
        model.put("codeList_19", codeList_19);
        model.put("codeList_322", codeList_322);
    		model.put("hcPreOrdInfo", hcPreOrdInfo);
    		model.put("orderInfo", matOrderInfo);
    		model.put("orderInfo2", frmOrderInfo);
    		model.put("COPY_CHANGE_YN", "Y");
    		model.put("matOrdId", matOrdId);
    		model.put("fraOrdId", fraOrdId);
    		model.put("ordSeqNo", hcPreOrdInfo.get("ordSeqNo"));
    		model.put("toDay", CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT1));

		return "homecare/sales/order/hcOrderRegisterPop";
	}

	@RequestMapping(value = "/oldOrderPop.do")
	  public String oldOrderPop(@RequestParam Map<String, Object> params, ModelMap model) {

		Map<String, Object> cParam = new HashMap();

		boolean isHc = String.valueOf(params.get("busType")).equals("HOMECARE") ? true : false;

		cParam.put("ordNo", params.get("salesOrdNo"));

		EgovMap rMap = null;
		String bundleId = "";
		String anoOrderNo = "";
		if(isHc){
			rMap = hcOrderListService.selectHcOrderInfo(cParam);
			bundleId = rMap.get("bndlNo") == null ? "" : rMap.get("bndlNo").toString();
			anoOrderNo = rMap.get("anoOrdNo") == null ? "" : rMap.get("anoOrdNo").toString();
		}

		model.put("bundleId", bundleId);
		model.put("anoOrderNo", anoOrderNo);

	    return "homecare/sales/order/oldOrderPop";
	  }

	  @RequestMapping(value = "/hcCheckPreBookConfigurationPerson.do", method = RequestMethod.GET)
	  public ResponseEntity<EgovMap> hcCheckPreBookConfigurationPerson(@RequestParam Map<String, Object> params) {

	    EgovMap result = orderRegisterService.checkPreBookConfigurationPerson(params);

	    return ResponseEntity.ok(result);
	  }

	  @RequestMapping(value = "/pwpOrderNoPop.do")
	  public String pwpOrderNoPop(@RequestParam Map<String, Object> params, ModelMap model) {

	    model.put("custId", params.get("custId"));
	    logger.info("[pwpOrderNoPop] :: custId :: " + params.get("custId"));
	    return "homecare/sales/order/pwpOrderNoPop";
	  }

	  @RequestMapping(value = "/selectPwpOrderNoList.do", method = RequestMethod.GET)
	  public ResponseEntity<List<EgovMap>> selectPwpOrderNoList(@RequestParam Map<String, Object> params) {
	    List<EgovMap> result = hcOrderRegisterService.selectPwpOrderNoList(params);
	    return ResponseEntity.ok(result);
	  }

	  @RequestMapping(value = "/checkPwpOrderId.do", method = RequestMethod.GET)
	  public ResponseEntity<EgovMap> checkPwpOrderId(@RequestParam Map<String, Object> params, ModelMap model) throws ParseException {
	    EgovMap RESULT = hcOrderRegisterService.checkPwpOrderId(params);
	    return ResponseEntity.ok(RESULT);
	  }

	  @RequestMapping(value = "/pwpOrderPop.do")
	  public String pwpOrderPop(@RequestParam Map<String, Object> params, ModelMap model) {

//		Map<String, Object> cParam = new HashMap();
//
//		cParam.put("ordNo", params.get("salesOrdNo"));
//
//		EgovMap rMap = null;
//		String bundleId = "";
//		String anoOrderNo = "";
//		if(isHc){
//			rMap = hcOrderListService.selectHcOrderInfo(cParam);
//			bundleId = rMap.get("bndlNo").toString();
//			anoOrderNo = rMap.get("anoOrdNo").toString();
//		}

//		model.put("bundleId", bundleId);
//		model.put("anoOrderNo", anoOrderNo);

	    return "homecare/sales/order/pwpOrderPop";
	  }

	  @RequestMapping(value = "/selectSeda4PromoList.do", method = RequestMethod.GET)
	  public ResponseEntity<ReturnMessage> selectSeda4PromoList(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {
	    ReturnMessage message = new ReturnMessage();

	    logger.info("==================/selectSeda4PromoList.do=======================");

	    List<EgovMap> seda4List = hcOrderRegisterService.selectSeda4PromoList(params);

	    message.setDataList(seda4List);
//	    message.setCode(Integer.toString(statCode));
	    return ResponseEntity.ok(message);
	  }

   @RequestMapping(value = "/selectLastHcAcCmbOrderInfo.do", method = RequestMethod.GET)
    public ResponseEntity<String> selectLastHcAcCmbOrderInfo(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO){
      logger.debug("[HcOrderRegisterController - selectLastHcAcCmbOrderInfo] params : {}", params);
      String prvOrdOriNorRntFee = hcOrderRegisterService.selectLastHcAcCmbOrderInfo(params);
      return ResponseEntity.ok(prvOrdOriNorRntFee);
    }

    @RequestMapping(value = "/chkHcAcCmbOrdStus.do", method = RequestMethod.POST)
    public ResponseEntity<ReturnMessage> chkHcAcCmbOrdStus(@RequestBody Map<String, Object> params, ModelMap model, SessionVO sessionVO) {
      ReturnMessage message = new ReturnMessage();

      logger.debug("==================/chkHcAcCmbOrdStus=======================");
      logger.debug("[HcOrderRegisterController - chkHcAcCmbOrdStus] params : {}", params);
      logger.debug("==================/chkHcAcCmbOrdStus=======================");

      int cmbOrdStus =  hcOrderRegisterService.chkHcAcCmbOrdStus(params);
      message.setCode(Integer.toString(cmbOrdStus));
      return ResponseEntity.ok(message);
    }

    @RequestMapping(value = "/chkSeqGrpAcCmbPromoPerOrd.do", method = RequestMethod.POST)
    public ResponseEntity<ReturnMessage> chkSeqGrpAcCmbPromoPerOrd(@RequestBody Map<String, Object> params, ModelMap model, SessionVO sessionVO) {

      ReturnMessage message = new ReturnMessage();

      logger.debug("==================/chkSeqGrpAcCmbPromoPerOrd=======================");
      logger.debug("[HcOrderRegisterController - chkSeqGrpAcCmbPromoPerOrd] params : {}", params);
      logger.debug("==================/chkSeqGrpAcCmbPromoPerOrd=======================");

      int seqGrpCmbPromo =  hcOrderRegisterService.chkSeqGrpAcCmbPromoPerOrd(params);
      logger.info("[HcOrderRegisterController - chkSeqGrpAcCmbPromoPerOrd] seqGrpCmbPromo :: " + seqGrpCmbPromo);

      message.setCode(Integer.toString(seqGrpCmbPromo));
      return ResponseEntity.ok(message);
    }

    @RequestMapping(value = "/rebateOrderNoPop.do")
	  public String rebateOrderNoPop(@RequestParam Map<String, Object> params, ModelMap model) {

	    model.put("custId", params.get("custId"));
	    logger.info("[rebateOrderNoPop] :: custId :: " + params.get("custId"));
	    return "homecare/sales/order/rebateOrderNoPop";
	  }

    @RequestMapping(value = "/selectRebateOrderNoList.do", method = RequestMethod.GET)
	  public ResponseEntity<List<EgovMap>> selectRebateOrderNoList(@RequestParam Map<String, Object> params) {
	    List<EgovMap> result = hcOrderRegisterService.selectRebateOrderNoList(params);
	    return ResponseEntity.ok(result);
	  }
}
