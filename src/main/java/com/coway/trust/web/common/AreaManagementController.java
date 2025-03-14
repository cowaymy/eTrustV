package com.coway.trust.web.common;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

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
import com.coway.trust.biz.common.AreaManagementService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.handler.SessionHandler;
import com.coway.trust.util.CommonUtils;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/common")
public class AreaManagementController {

	private static final Logger LOGGER = LoggerFactory.getLogger(AreaManagementController.class);

	@Autowired
	private MessageSourceAccessor messageAccessor;

	@Resource(name = "areaManagementService")
	private AreaManagementService areaManagementService;

	@Autowired
	private SessionHandler sessionHandler;

	@RequestMapping(value = "/areaManagement.do")
	public String areaManagement(@RequestParam Map<String, Object> params, ModelMap model) throws Exception {
		return "common/areaManagement";
	}

	@RequestMapping(value = "/selectAreaManagement", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectAreaManagement(@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model) throws Exception {
		List<EgovMap> selectAreaManagement = null;
		selectAreaManagement = areaManagementService.selectAreaManagement(params);
		return ResponseEntity.ok(selectAreaManagement);
	}

	@RequestMapping(value = "/saveAreaManagement.do", method = RequestMethod.POST)
	public  ResponseEntity<ReturnMessage> saveAreaManagement(@RequestBody Map<String, ArrayList<Object>> params, Model model) {

		String dt = CommonUtils.getNowDate();

		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
		String loginId = "";
		if(sessionVO==null){
			loginId="1000000000";
		}else{
			loginId=String.valueOf(sessionVO.getUserId());
		}

		List<Object> udtList = params.get(AppConstants.AUIGRID_UPDATE); 	// Get gride UpdateList

		int cnt = 0;

		if (udtList.size() > 0) {
			cnt = areaManagementService.udtAreaManagement(udtList, loginId);
		}

		model.addAttribute("searchDt", dt);

		// 결과 만들기 예.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/areaCopyAddressMasterPop.do")
	public String areaCopyAddressMasterPop(@RequestParam Map<String, Object> params, ModelMap model) throws Exception {

		LOGGER.debug("params =====================================>>  " + params);

		model.addAttribute("popAreaId", params.get("popAreaId").toString());
		model.addAttribute("popArea", params.get("popArea").toString());
		model.addAttribute("popPostcode", params.get("popPostcode").toString());
		model.addAttribute("popCity", params.get("popCity").toString());
		model.addAttribute("popState", params.get("popState").toString());
		model.addAttribute("popCountry", params.get("popCountry").toString());
		model.addAttribute("popStatusId", params.get("popStatusId").toString());
		model.addAttribute("popId", params.get("popId").toString());


		return "common/areaCopyAddressMasterPop";
	}

	@RequestMapping(value = "/saveCopyAddressMaster.do", method = RequestMethod.POST)
	public  ResponseEntity<ReturnMessage>  saveCopyAddressMaster(@RequestBody Map<String, ArrayList<Map<String, Object>>> params, Model model) {

		String dt = CommonUtils.getNowDate();

		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
		String loginId = "";
		if(sessionVO==null){
			loginId="1000000000";
		}else{
			loginId=String.valueOf(sessionVO.getUserId());
		}

		List<Map<String, Object>> addList = params.get(AppConstants.AUIGRID_ADD); 		// Get grid addList
		// 결과 만들기
		ReturnMessage message = new ReturnMessage();
		model.addAttribute("searchDt", CommonUtils.getNowDate());

		if (addList.size() > 0) {
			// 동일한 AreA가 있는경우는 저장불가.
			boolean isRedup = areaManagementService.isRedupAddCopyAddressMaster(addList);
			if(isRedup) {
				message.setCode(AppConstants.FAIL);
				message.setMessage("The same area already exists.");

			} else {
				areaManagementService.addCopyAddressMaster(addList, loginId);

				message.setCode(AppConstants.SUCCESS);
				message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
			}
		}

		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/saveCopyOtherAddressMaster.do", method = RequestMethod.POST)
	public  ResponseEntity<ReturnMessage>  saveCopyOtherAddressMaster(@RequestBody Map<String, ArrayList<Map<String, Object>>> params, Model model) {
		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
		String loginId = "";
		if(sessionVO==null){
			loginId="1000000000";
		}else{
			loginId=String.valueOf(sessionVO.getUserId());
		}

		List<Map<String, Object>> addList = params.get(AppConstants.AUIGRID_ADD); 		// Get grid addList
		// 결과 만들기
		ReturnMessage message = new ReturnMessage();
		model.addAttribute("searchDt", CommonUtils.getNowDate());

		if (addList.size() > 0) {
			// 동일한 AreA가 있는경우는 저장불가.
			boolean isRedup = areaManagementService.isRedupAddCopyAddressMaster(addList);
			if(isRedup) {
				message.setCode(AppConstants.FAIL);
				message.setMessage("The same area already exists.");

			} else {
				areaManagementService.addCopyOtherAddressMaster(addList, loginId);

				message.setCode(AppConstants.SUCCESS);
				message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
			}
		}

		return ResponseEntity.ok(message);
	}


	@RequestMapping(value = "/areaNewAddressMyPop.do")
	public String areaNewAddressMyPop(@RequestParam Map<String, Object> params, ModelMap model) throws Exception {

		return "common/areaNewAddressMyPop";
	}

	@RequestMapping(value = "/areaNewAddressOtherPop.do")
	public String areaNewAddressOtherPop(@RequestParam Map<String, Object> params, ModelMap model) throws Exception {

		return "common/areaNewAddressOtherPop";
	}

	@RequestMapping(value = "/saveOtherAddressMaster.do", method = RequestMethod.POST)
	public  ResponseEntity<ReturnMessage> saveOtherAddressMaster(@RequestBody Map<String, ArrayList<Object>> params, Model model) {

		String dt = CommonUtils.getNowDate();

		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
		String loginId = "";
		if(sessionVO==null){
			loginId="1000000000";
		}else{
			loginId=String.valueOf(sessionVO.getUserId());
		}

		List<Object> addList = params.get(AppConstants.AUIGRID_ADD); 		// Get grid addList

		int cnt = 0;

		if (addList.size() > 0) {
			cnt = areaManagementService.addOtherAddressMaster(addList, loginId);
		}

		model.addAttribute("searchDt", dt);

		// 결과 만들기 예.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/saveMyAddressMaster.do", method = RequestMethod.POST)
	public  ResponseEntity<ReturnMessage> saveMyAddressMaster(@RequestBody Map<String, ArrayList<Object>> params, Model model) {

		String dt = CommonUtils.getNowDate();

		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
		String loginId = "";
		if(sessionVO==null){
			loginId="1000000000";
		}else{
			loginId=String.valueOf(sessionVO.getUserId());
		}

		List<Object> addList = params.get(AppConstants.AUIGRID_ADD); 		// Get grid addList

		int cnt = 0;

		if (addList.size() > 0) {
			cnt = areaManagementService.addMyAddressMaster(addList, loginId);
		}

		model.addAttribute("searchDt", dt);

		// 결과 만들기 예.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/selectMyPostcode", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectMyPostcode(@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model) throws Exception {
		List<EgovMap> selectMyPostcode = null;
		selectMyPostcode = areaManagementService.selectMyPostcode(params);

		return ResponseEntity.ok(selectMyPostcode);
	}

    @RequestMapping(value = "/selectBlackAreaList")
    public ResponseEntity<List<EgovMap>> selectBlackArea (@RequestParam Map<String, Object> params) throws Exception{

        LOGGER.info("######################  get Black Area Detail ###################");
        List<EgovMap> detailList = null;
        detailList = areaManagementService.selectBlackArea(params);

        return ResponseEntity.ok(detailList);
    }

	@RequestMapping(value = "/editBlackAreaPop.do")
	public String editBlackAreaPop(@RequestParam Map<String, Object> params, ModelMap model) throws Exception {
		LOGGER.debug("params editBlackAreaPop ================================>>  " + params);
		model.put("areaId", params.get("popAreaId"));
		model.put("blckAreaGrpId", params.get("popBlckAreaGrpId"));
		LOGGER.debug("model editBlackAreaPop ================================>>  " + model);
		return "common/editBlackAreaPop";
	}

	@RequestMapping(value = "/selectProductCatergory.do", method = RequestMethod.GET)
	public ResponseEntity<Map> selectProductCatergory(Model model, HttpServletRequest request, HttpServletResponse response) throws Exception {
		Map<String, Object> result = new HashMap();

	    List<EgovMap> list = areaManagementService.selectProductCategory(result);

	    result.put("data", list);

	    return ResponseEntity.ok(result);
	  }

	@RequestMapping(value = "/selectBlacklistedArea.do", method = RequestMethod.GET)
	public ResponseEntity<Map> selectBlacklistedArea(@RequestParam Map<String, Object> params, Model model, HttpServletRequest request, HttpServletResponse response) throws Exception {
		Map<String, Object> result = new HashMap();

		String areaId = request.getParameter("areaId");

		params.put("areaId", areaId);

	    List<EgovMap> list = areaManagementService.selectBlacklistedArea(params);

	    result.put("data", list);

	    return ResponseEntity.ok(result);
	  }

	  @RequestMapping(value = "/updateBlacklistedArea.do", method = RequestMethod.POST)
	  public ResponseEntity<ReturnMessage> stockMovementService(@RequestBody Map<String, Object> params, Model model) {
	    SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
	    int loginId;
	    if (sessionVO == null) {
	      loginId = 99999999;
	    } else {
	      loginId = sessionVO.getUserId();
	    }
	    Map<String, Object> itemGridList = (Map<String, Object>) params.get("itemGridList");
	    List<Object> insList= (List<Object>)itemGridList.get(AppConstants.AUIGRID_ALL);
	    List<Object> updList = (List<Object>) params.get(AppConstants.AUIGRID_UPDATE);
	    List<Object> remList = (List<Object>) params.get(AppConstants.AUIGRID_REMOVE);

	    Map<String, Object> formMap = (Map<String, Object>) params.get(AppConstants.AUIGRID_FORM);

	    Map<String, Object> param = new HashMap();
	    param.put("all", insList);
	    param.put("form", formMap);
	    param.put("userId", loginId);
	    String reqNo = areaManagementService.insertBlacklistedArea(param);

	    // 결과 만들기 예.
	    ReturnMessage message = new ReturnMessage();
	    if (reqNo != null && !"".equals(reqNo)) {
	      // 결과 만들기 예.
	      message.setCode(AppConstants.SUCCESS);
	      message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

	    } else {
	      message.setCode(AppConstants.FAIL);
	      message.setMessage(messageAccessor.getMessage(AppConstants.MSG_FAIL));
	    }

	    message.setData(reqNo);

	    return ResponseEntity.ok(message);
	  }

}
