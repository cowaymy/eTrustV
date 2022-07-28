package com.coway.trust.web.services.as;

import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
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
import com.coway.trust.biz.common.AdaptorService;
import com.coway.trust.biz.sales.order.OrderDetailService;
import com.coway.trust.biz.services.as.PreASManagementListService;
import com.coway.trust.biz.services.as.ASManagementListService;
import com.coway.trust.biz.services.as.InHouseRepairService;
import com.coway.trust.biz.services.as.ServicesLogisticsPFCService;
import com.coway.trust.biz.services.bs.HsManualService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.cmmn.model.SmsResult;
import com.coway.trust.cmmn.model.SmsVO;
import com.coway.trust.config.handler.SessionHandler;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.web.sales.SalesConstants;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/services/as")
public class PreASManagementListController {
  private static final Logger logger = LoggerFactory.getLogger(PreASManagementListController.class);

  @Resource(name = "PreASManagementListService")
  private PreASManagementListService PreASManagementListService;

  @Resource(name = "ASManagementListService")
  private ASManagementListService ASManagementListService;

  @Resource(name = "orderDetailService")
  private OrderDetailService orderDetailService;

  @Resource(name = "hsManualService")
  private HsManualService hsManualService;

  @Resource(name = "InHouseRepairService")
  private InHouseRepairService inHouseRepairService;

  @Resource(name = "servicesLogisticsPFCService")
  private ServicesLogisticsPFCService servicesLogisticsPFCService;

  @Autowired
  private AdaptorService adaptorService;

  @Autowired
  private SessionHandler sessionHandler;

  @Autowired
  private MessageSourceAccessor messageAccessor;

  @RequestMapping(value = "/initPreASManagementList.do")
  public String initASManagementList(@RequestParam Map<String, Object> params, ModelMap model) {
    logger.debug("===========================/initPreASManagementList.do===============================");
    logger.debug("== params " + params.toString());
    logger.debug("===========================/initPreASManagementList.do===============================");

    // GET SEARCH DATE RANGE
    String range = ASManagementListService.getSearchDtRange();

    List<EgovMap> asTyp = ASManagementListService.selectAsTyp();
    List<EgovMap> asStat = PreASManagementListService.selectPreAsStat();
    List<EgovMap> asProduct = ASManagementListService.asProd();

    model.put("DT_RANGE", CommonUtils.nvl(range));
    model.put("asTyp", asTyp);
    model.put("asStat", asStat);
    model.put("asProduct", asProduct);

    String bfDay = CommonUtils.changeFormat(CommonUtils.getCalDate(-30), SalesConstants.DEFAULT_DATE_FORMAT3,
        SalesConstants.DEFAULT_DATE_FORMAT1);
    String toDay = CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT1);

    model.put("bfDay", bfDay);
    model.put("toDay", toDay);
    return "services/as/preASManagementList";
  }

  @RequestMapping(value = "/searchPreASManagementList.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectPreASManagementList(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model) {
    logger.debug("===========================/searchPreASManagementList.do===============================");
    logger.debug("== params heres" + params.toString());

    String[] asProductList = request.getParameterValues("asProduct");
    String[] asStatusList = request.getParameterValues("asStatus");
    String[] cmbbranchIdList = request.getParameterValues("cmbbranchId");

    // String cmbctId = request.getParameter("cmbctId");

    params.put("asStatusList", asStatusList);
    params.put("cmbbranchIdList", cmbbranchIdList);
    params.put("asProductList", asProductList);

    List<EgovMap> PreASMList = PreASManagementListService.selectPreASManagementList(params);

    // logger.debug("== ASMList : {}", ASMList);
    logger.debug("===========================/searchPreASManagementList.do===============================");
    return ResponseEntity.ok(PreASMList);
  }

  @RequestMapping(value = "/rejectPreASOrder.do")
	public String rejectPreASOrder(@RequestParam Map<String, Object> params, ModelMap model) {

	  logger.debug("== params rejectPreASOrder" + params.toString());
	  	model.put("salesOrdNo", params.get("preAsSalesOrderNo").toString());
	  	model.put("branchCode",  params.get("preAsBranch").toString());
		return "services/as/rejectPreASOrderPop";
	}

  @RequestMapping(value = "/updateRejectedPreAS.do", method = RequestMethod.POST)
  public ResponseEntity<ReturnMessage> updatePosEshopItemList(@RequestBody Map<String, Object> params) throws Exception {
    SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
    params.put("userId", sessionVO.getUserId());
    params.put("userDeptId", sessionVO.getUserDeptId());
    params.put("userName", sessionVO.getUserName());

    Map<String, Object> retunMap = null;

    retunMap = PreASManagementListService.updateRejectedPreAS(params);

	//Return Message
	ReturnMessage message = new ReturnMessage();
	message.setCode(AppConstants.SUCCESS);
	message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

    return ResponseEntity.ok(message);

  }

  @RequestMapping(value = "/preAsRawDataPop.do")
	public String preAsRawDataPop(@RequestParam Map<String, Object> params, ModelMap model) {
		model.addAttribute("ind", params.get("ind"));
		return "services/as/preAsRawDataPop";
	}

}
