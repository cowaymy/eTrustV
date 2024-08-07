package com.coway.trust.web.sales.customer;

import java.util.List;
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
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.AppConstants;
import com.coway.trust.api.mobile.common.CommonConstants;
import com.coway.trust.biz.sales.customer.CustomerMobileContactUpdateService;
import com.coway.trust.biz.sales.customer.CustomerVO;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.handler.SessionHandler;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/sales/customer")
public class CustomerMobileContactUpdateController {

  private static final Logger LOGGER = LoggerFactory.getLogger(CustomerMobileContactUpdateController.class);

  @Resource(name = "customerMobileContactUpdateService")
  private CustomerMobileContactUpdateService customerMobileContactUpdateService;

  @Autowired
  private MessageSourceAccessor messageAccessor;

  @Autowired
  private SessionHandler sessionHandler;


  @RequestMapping(value = "/customerMobileContactUpdate.do")
  public String customerMobileContactUpdate(@ModelAttribute("customerVO") CustomerVO customerVO, @RequestParam Map<String, Object> params, ModelMap model) {

    return "sales/customer/customerMobileContactUpdate";
  }

  @RequestMapping(value = "/selectMobileUpdateJsonList", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectMobileUpdateJsonList(@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model) {
	  List<EgovMap> mobileUpdateList = null;
	  String[] statusList = request.getParameterValues("status");
	  params.put("statusList", statusList);
	  LOGGER.info("##### params START #####");
	  LOGGER.info("params: " + params);
	  mobileUpdateList = customerMobileContactUpdateService.selectMobileUpdateJsonList(params);
	  LOGGER.info("mobileUpdateList: " + mobileUpdateList);

	  return ResponseEntity.ok(mobileUpdateList);

  }

  @RequestMapping(value = "/customerMobileContactUpdateDetailView.do")
  public String customerMobileContactUpdateDetailView(@RequestParam Map<String, Object> params, ModelMap model) throws Exception {
	  EgovMap contactInfo = null;

	  LOGGER.info("##### customerMobileContactUpdateDetailView START #####");
	  contactInfo = customerMobileContactUpdateService.selectMobileUpdateDetail(params);
	  contactInfo.put("statusCode",params.get("statusCode"));

	  model.addAttribute("contactInfo", contactInfo);

	  return "sales/customer/customerMobileContactUpdateDetailViewPop";
  }

  @RequestMapping(value = "/updateAppvStatus.do", method = RequestMethod.POST)
  public ResponseEntity<ReturnMessage> updateAppvStatus(@RequestBody Map<String, Object> params, ModelMap model, SessionVO sessionVO) throws Exception {
	  LOGGER.info("##### updateAppvStatus START #####");
	  LOGGER.info("params: " + params);

	  params.put(CommonConstants.USER_ID, sessionVO.getUserId());
	  customerMobileContactUpdateService.updateAppvStatus(params);

	  ReturnMessage message = new ReturnMessage();
	  message.setCode(AppConstants.SUCCESS);
	  message.setData(params);
	  message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

	  return ResponseEntity.ok(message);
  }

}
