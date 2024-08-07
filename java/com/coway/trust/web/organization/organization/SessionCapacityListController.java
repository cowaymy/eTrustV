package com.coway.trust.web.organization.organization;

import java.util.ArrayList;
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
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.organization.organization.SessionCapacityListService;
import com.coway.trust.biz.sales.order.OrderCancelService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/organization")
public class SessionCapacityListController {

	private static final Logger logger = LoggerFactory.getLogger(MemberRawDataController.class);

	@Resource(name = "orderCancelService")
	private OrderCancelService orderCancelService;

	@Resource(name = "sessionCapacityListService")
	private SessionCapacityListService sessionCapacityListService;

	// DataBase message accessor....
	@Autowired
	private MessageSourceAccessor messageAccessor;



	@RequestMapping(value = "/initSessionCapacityList.do")
	public String initSessionCapacityList(@RequestParam Map<String, Object> params, ModelMap model) {

		List<EgovMap> dscBranchList =   sessionCapacityListService.seleBranchCodeSearch(params);
		params.put("groupCode", 43);

		logger.debug("dscBranchList : {}", dscBranchList);
		model.addAttribute("dscBranchList", dscBranchList);
		return "organization/organization/sessionCapacityList";
	}




	@RequestMapping(value = "/initSessionCapacityCtList.do")
	public String initSessionCapacityCtList(@RequestParam Map<String, Object> params, ModelMap model) {

		List<EgovMap> dscBranchList =  orderCancelService.dscBranch(params);
		model.addAttribute("dscBranchList", dscBranchList);

		return "organization/organization/sessionCapacityCtList";
	}



	@RequestMapping(value = "/selectSsCapacityBrList", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectSsCapacityBrList(@RequestParam Map<String, Object>params, HttpServletRequest request, ModelMap model) {

		List<EgovMap> ssCapacityBrList = null;
		String[] branchList = request.getParameterValues("cmbbranchId");
		params.put("branchList",branchList); // ct/br gb
        // 조회.
		ssCapacityBrList = sessionCapacityListService.selectSsCapacityBrList(params);
		params.put("brGb", "br"); // ct/br gb

		return ResponseEntity.ok(ssCapacityBrList);
	}


	@RequestMapping(value = "/selectSsCapacityCtList", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectSsCapacityCtList(@RequestParam Map<String, Object>params, HttpServletRequest request, ModelMap model) {

		List<EgovMap> ssCapacityCtList = null;

        // 조회.
		ssCapacityCtList = sessionCapacityListService.selectSsCapacityBrList(params);

		return ResponseEntity.ok(ssCapacityCtList);
	}

	@RequestMapping(value = "/selectSsCapacityCtListEnhance", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectSsCapacityCtListEnhance(@RequestParam Map<String, Object>params, HttpServletRequest request, ModelMap model) {

		List<EgovMap> ssCapacityCtList = null;

        // 조회.
		ssCapacityCtList = sessionCapacityListService.selectSsCapacityBrListEnhance(params);

		return ResponseEntity.ok(ssCapacityCtList);
	}

	@RequestMapping(value = "/selectSsCapacityCTM", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectSsCapacityCTM(@RequestParam Map<String, Object>params, HttpServletRequest request, ModelMap model) {

		List<EgovMap> ssCapacityCTM = null;

        // 조회.
		ssCapacityCTM = sessionCapacityListService.selectSsCapacityCTM(params);

		return ResponseEntity.ok(ssCapacityCTM);
	}



	/**
	 * Map을 이용한 Grid 편집 데이터 저장/수정/삭제 데이터 처리 샘플.
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/saveSsCapacityBrList.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> saveSsCapacityBrList(@RequestBody Map<String, ArrayList<Object>> params,
			Model model) {

		List<Object> updateList = params.get(AppConstants.AUIGRID_UPDATE); // 수정 리스트 얻기
		List<Object> addList = params.get(AppConstants.AUIGRID_ADD); // 추가 리스트 얻기
		List<Object> removeList = params.get(AppConstants.AUIGRID_REMOVE); // 제거 리스트 얻기

        // 저장.
		//sessionCapacityListService.saveSsCapacityBrList(params);

		// 반드시 서비스 호출하여 비지니스 처리. (현재는 샘플이므로 로그만 남김.)
		if (updateList.size() > 0) {
			Map hm = null;
			Map<String, Object> updateMap = (Map<String, Object>) updateList.get(0);

			logger.info("0 번째 id : {}", updateMap.get("id"));

			updateList.forEach(obj -> {
				logger.debug("update id : {}", ((Map<String, Object>) obj).get("id"));
				logger.debug("update name : {}", ((Map<String, Object>) obj).get("name"));
			});
		}

		// 콘솔로 찍어보기
		logger.info("수정 : {}", updateList.toString());
		logger.info("추가 : {}", addList.toString());
		logger.info("삭제 : {}", removeList.toString());

		// 결과 만들기 예.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}

	/**
	 * Search rule book management list
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/saveCapacity.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage>selectComfirmTerritory(@RequestBody Map<String, ArrayList<Object>> params, ModelMap model, SessionVO sessionVO) {
		ReturnMessage message = new ReturnMessage();
		boolean addSuccess = false;
		boolean updateSuccess = false;
		boolean delSuccess = false;
		EgovMap rtm = new EgovMap();

		List<Object> addList = params.get(AppConstants.AUIGRID_ADD); 		// Get grid addList
		List<Object> udtList = params.get(AppConstants.AUIGRID_UPDATE); 	// Get gride UpdateList
		List<Object> delList = params.get(AppConstants.AUIGRID_REMOVE);  // Get grid DeleteList

		logger.debug("addList {}", addList);
//		if(addList != null){
//			sessionCapacityListService.insertCapacity(addList,sessionVO);
//		}
		if(udtList != null){
			sessionCapacityListService.updateCapacityEnhance(udtList,sessionVO);
			//sessionCapacityListService.updateCTMCapacityEnhance(udtList,sessionVO);
			sessionCapacityListService.deleteCapacity(udtList,sessionVO);
		}
//		if(delList != null){
//			sessionCapacityListService.deleteCapacity(delList,sessionVO);
//		}

//		if(addSuccess){
//			message.setMessage("Save Success CT Session Capacity");
//		}else{
//			message.setMessage("Save Fail CT Session Capacity");
//		}
		if(updateSuccess){
			message.setMessage("Save Success CT Session Capacity");
		}else{
			message.setMessage("Save Fail CT Session Capacity");
		}
//		if(delSuccess){
//			message.setMessage("Delete Success CT Session Capacity");
//		}else{
//			message.setMessage("Delete Fail CT Session Capacity");
//		}
		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/seleCtCodeSearch.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> seleCtCodeSearch(@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model) {
		logger.debug("params {}", params);
		List<EgovMap> ssCapacityCtList = null;

        // 조회.
		ssCapacityCtList = sessionCapacityListService.seleCtCodeSearch(params);
		logger.debug("ssCapacityCtList {}", ssCapacityCtList);

		return ResponseEntity.ok(ssCapacityCtList);
	}

	@RequestMapping(value = "/seleCtCodeSearch2.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> seleCtCodeSearch2(@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model) {
		logger.debug("params {}", params);
		List<EgovMap> ssCapacityCtList2 = null;

        // 조회.
		ssCapacityCtList2 = sessionCapacityListService.seleCtCodeSearch2(params);
		logger.debug("ssCapacityCtList {}", ssCapacityCtList2);

		return ResponseEntity.ok(ssCapacityCtList2);
	}

	@RequestMapping(value = "/seleBranchCodeSearch.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> seleBranchCodeSearch(@RequestParam Map<String, Object>params, HttpServletRequest request, ModelMap model) {

		List<EgovMap> ssCapacityCtList = null;

        // 조회.
		ssCapacityCtList = sessionCapacityListService.seleBranchCodeSearch(params);

		return ResponseEntity.ok(ssCapacityCtList);
	}

	@RequestMapping(value = "/selectAllCarModelList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectAllCarModelList(HttpServletRequest request, ModelMap model) {
		List<EgovMap> carModelList = null;

        // 조회.
		carModelList = sessionCapacityListService.selectAllCarModelList();
		logger.debug("carTypeCTList {}", carModelList);

		return ResponseEntity.ok(carModelList);
	}
}
