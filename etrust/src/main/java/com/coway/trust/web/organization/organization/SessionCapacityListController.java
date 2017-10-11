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

		List<EgovMap> dscBranchList =  orderCancelService.dscBranch(params);
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
	
	
	
	
	
	
	
	
	
	
//	
//	@RequestMapping(value = "/selectOrgChartHpList.do", method = RequestMethod.GET)
//	public ResponseEntity<List<EgovMap>> selectOrgChartHpList(@RequestParam Map<String, Object>params, HttpServletRequest request, ModelMap model) {
//		
//		List<EgovMap> orgChartHpList = null;
//		
//        // 조회.
//		orgChartHpList = orgChartListService.selectOrgChartHpList(params);        
//
//		return ResponseEntity.ok(orgChartHpList);
//	}
//	
//	
//	
//	
//	@RequestMapping(value = "/selectHpChildList.do", method = RequestMethod.GET)
//	public ResponseEntity<List<EgovMap>> selectHpChildList(@RequestParam Map<String, Object>params, HttpServletRequest request, ModelMap model) {
//		
//        // 조회.
//		List<EgovMap> orgHpChildList = orgChartListService.selectHpChildList(params);        
//		
//		return ResponseEntity.ok(orgHpChildList);
//	}
//	
//	
//
//	
//		
//	@RequestMapping(value = "/getDeptTreeList.do", method = RequestMethod.GET)
//	public ResponseEntity<List<EgovMap>> getDeptTreeList(@RequestParam Map<String, Object>params) {
//        // Member Type 에 따른 Organization 조회.
//		List<EgovMap> resultList = orgChartListService.getDeptTreeList(params);        
//
//		return ResponseEntity.ok(resultList);
//	}
//	
//	
//	
//	@RequestMapping(value = "/getGroupTreeList.do", method = RequestMethod.GET)
//	public ResponseEntity<List<EgovMap>> getGroupTreeList(@RequestParam Map<String, Object>params) {
//       
//		logger.debug("  "+params.toString());
//		//Member Type 이 선행 조회된 이후(고정) Member Id 변경 시
//		// 조회.
//		List<EgovMap> resultList = orgChartListService.getGroupTreeList(params); 
//		
//		return ResponseEntity.ok(resultList);
//	}
//	
//	
//	
//	
//	
//	
//	
//	
//	
//	
//	
//	@RequestMapping(value = "/selectOrgChartCdList.do", method = RequestMethod.GET)
//	public ResponseEntity<List<EgovMap>> selectCdChildList(@RequestParam Map<String, Object>params, HttpServletRequest request, ModelMap model) {
//		
//        // 조회.
//		List<EgovMap> orgChartCdList = orgChartListService.selectOrgChartCdList(params);        
//		
//		return ResponseEntity.ok(orgChartCdList);
//	}
//	
	
	
	/////////////
//	@RequestMapping(value = "/selectOrgChartCtList.do", method = RequestMethod.GET)
//	public ResponseEntity<List<EgovMap>> selectCtChildList(@RequestParam Map<String, Object>params, HttpServletRequest request, ModelMap model) {
//		
//        // 조회.
//		List<EgovMap> orgChartCdList = orgChartListService.selectOrgChartCdList(params);        
//		
//		return ResponseEntity.ok(orgChartCdList);
//	}	
	
	
	
}
