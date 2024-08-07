/**
 *
 */
package com.coway.trust.web.commission.system;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

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
import com.coway.trust.biz.commission.system.CommissionSystemService;
import com.coway.trust.biz.sales.common.SalesCommonService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.handler.SessionHandler;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.web.commission.CommissionConstants;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @author Yunseok_Jang
 *
 */
@Controller
@RequestMapping(value = "/commission/system")
public class CommissionSystemController {

	private static final Logger logger = LoggerFactory.getLogger(CommissionSystemController.class);

	@Resource(name = "commissionSystemService")
	private CommissionSystemService commissionSystemService;

	@Resource(name = "salesCommonService")
	private SalesCommonService salesCommonService;

	@Value("${app.name}")
	private String appName;

	@Value("${com.file.upload.path}")
	private String uploadDir;

	// DataBase message accessor....
	@Autowired
	private MessageSourceAccessor messageAccessor;

	   @Autowired
	    private SessionHandler sessionHandler;

	/**
	 * Call commission rule book management Page
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/commissionRuleBookOrgMng.do")
	public String commissionRuleBookOrgMng(@RequestParam Map<String, Object> params, ModelMap model) {

		params.put("mstId", CommissionConstants.COMIS_EMP_CD);
		List<EgovMap> orgGrList = commissionSystemService.selectOrgGrList(params);
		model.addAttribute("orgGrList", orgGrList);
		params.put("mstId", CommissionConstants.COMIS_CD_CD);
		List<EgovMap> orgList = commissionSystemService.selectOrgList(params);
		String dt = CommonUtils.getNowDate().substring(0, 6);
		dt = dt.substring(4) + "/" + dt.substring(0, 4);

		model.addAttribute("searchDt", dt);
		model.addAttribute("orgGrList", orgGrList);
		model.addAttribute("orgList", orgList);
		// 호출될 화면
		return "commission/commissionRuleBookOrgMng";
	}

	/**
	 *  Organization Ajax Search
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectOrgList", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectJsonOrgList( @RequestParam Map<String, Object> params, ModelMap model) {

		// log 표준
		logger.debug("orgRgCombo : {}", params.get("orgRgCombo"));
		logger.debug("orgCombo : {}", params.get("orgCombo"));
		logger.debug("orgGubun : {}", params.get("orgGubun"));

		String orgGubun = String.valueOf(params.get("orgGubun"));
		String orgRg = ""	;

		if (orgGubun.equals("G")) {
			orgRg = String.valueOf(params.get("orgGrCd"));
		} else {
			orgRg = String.valueOf(params.get("orgRgCombo"));
		}

		String mstId = "";

		if (orgRg.equals(CommissionConstants.COMIS_CD_GRCD)) {
			mstId = CommissionConstants.COMIS_CD_CD;
		} else if (orgRg.equals(CommissionConstants.COMIS_CT_GRCD)) {
			mstId = CommissionConstants.COMIS_CT_CD;
		} else if (orgRg.equals(CommissionConstants.COMIS_HP_GRCD)) {
			mstId = CommissionConstants.COMIS_HP_CD;
		} else if(orgRg.equals(CommissionConstants.COMIS_HT_GRCD)) {
			mstId = CommissionConstants.COMIS_HT_CD;
		}

		params.put("mstId", mstId);

		// 조회.
		List<EgovMap> orgList = commissionSystemService.selectOrgList(params);

		// 데이터 리턴.
		return ResponseEntity.ok(orgList);
	}

	/**
	 * Use Map and Edit Grid Insert,Update,Delete
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/saveCommissionGrid.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> saveCommissionGrid(@RequestBody Map<String, ArrayList<Object>> params, Model model, SessionVO sessionVO) {

		String loginId = String.valueOf(sessionVO.getUserId());

		List<Object> udtList = params.get(AppConstants.AUIGRID_UPDATE); 	// Get gride UpdateList
		List<Object> addList = params.get(AppConstants.AUIGRID_ADD); 		// Get grid addList
		List<Object> delList = params.get(AppConstants.AUIGRID_REMOVE);  // Get grid DeleteList

		int cnt = 0;

		if (addList.size() > 0) {
			cnt = commissionSystemService.addCommissionGrid(addList,loginId);
		}
		if (udtList.size() > 0) {
			cnt = commissionSystemService.udtCommissionGrid(udtList,loginId);
		}
		if (delList.size() > 0) {
			cnt = commissionSystemService.delCommissionGrid(delList,loginId);
		}

		logger.info("수정 : {}", udtList.toString());
		logger.info("추가 : {}", addList.toString());
		logger.info("삭제 : {}", delList.toString());
		logger.info("카운트 : {}", cnt);

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
	@RequestMapping(value = "/selectRuleBookOrgMngList", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectRuleBookOrgMngList( @RequestParam Map<String, Object> params, ModelMap model) {

		logger.debug("orgRgCombo : {}", params.get("orgRgCombo"));
		logger.debug("orgCombo : {}", params.get("orgCombo"));
		logger.debug("searchDt : {}", params.get("searchDt"));

		String dt = String.valueOf(params.get("searchDt"));
		if (dt.trim().equals("")) {
			dt = CommonUtils.getNowDate().substring(0, 6);
			params.put("searchDt", dt);
		} else if (dt.contains("/")) {
			dt = dt.replaceAll("/", "");
			dt = dt.substring(2) + dt.substring(0, 2);
			params.put("searchDt", dt);
		}

		List<EgovMap> ruleBookMngList = commissionSystemService.selectRuleBookOrgMngList(params);

		// return grid data
		return ResponseEntity.ok(ruleBookMngList);
	}

	/**
	 * Call commission rule book Item management Page
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/commissionRuleBookItemMng.do")
	public String commissionRuleBookItemMng(@RequestParam Map<String, Object> params, ModelMap model) {

		List<EgovMap> orgGrList = commissionSystemService.selectOrgGrCdListAll(params);
		model.addAttribute("orgGrList", orgGrList);

		String dt = CommonUtils.getNowDate().substring(0, 6);
		params.put("searchDt", dt);
		List<EgovMap> orgList = commissionSystemService.selectOrgCdListAll(params);

		dt = dt.substring(4) + "/" + dt.substring(0, 4);

		model.addAttribute("searchDt", dt);
		model.addAttribute("orgGrList", orgGrList);
		model.addAttribute("orgList", orgList);
		// 호출될 화면
		return "commission/commissionRuleBookItemMng";
	}

	/**
	 *  Organization Ajax Search
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectOrgCdListAll", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectOrgCdListAll(@RequestParam Map<String, Object> params, ModelMap model) {

		// 조회.
		String dt = String.valueOf(params.get("searchDt"));
		dt = dt.substring(dt.indexOf("/")+1,dt.length())+dt.substring(0,dt.indexOf("/"));

		params.put("searchDt", dt);
		List<EgovMap> orgList = commissionSystemService.selectOrgCdListAll(params);

		// 데이터 리턴.
		return ResponseEntity.ok(orgList);
	}

	/**
	 *  Organization Ajax Search
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectOrgCdList", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectOrgCdList(@RequestParam Map<String, Object> params, ModelMap model) {

		// 조회.
		List<EgovMap> orgCdList = commissionSystemService.selectOrgCdList(params);

		// 데이터 리턴.
		return ResponseEntity.ok(orgCdList);
	}

	/**
	 *  Organization Ajax Search
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectOrgItemList", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectJsonOrgItemList( @RequestParam Map<String, Object> params, ModelMap model,HttpServletRequest request) {

		params.put("mstId", CommissionConstants.COMIS_ITEM_CD);
		// 조회.
		List<EgovMap> itemList = commissionSystemService.selectOrgItemList(params);

		// 데이터 리턴.
		return ResponseEntity.ok(itemList);
	}

	/**
	 * Search rule book Item management list
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectRuleBookItemMngList", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectRuleBookItemMngList(@RequestParam Map<String, Object> params, ModelMap model) {

		String dt = String.valueOf(params.get("searchDt"));
		if (dt.trim().equals("")) {
			dt = CommonUtils.getNowDate().substring(0, 6);
			params.put("searchDt", dt);
		} else if (dt.contains("/")) {
			dt = dt.replaceAll("/", "");
			dt = dt.substring(2) + dt.substring(0, 2);
			params.put("searchDt", dt);
		}

		List<EgovMap> ruleBookMngList = commissionSystemService.selectRuleBookItemMngList(params);

		// return grid data
		return ResponseEntity.ok(ruleBookMngList);
	}

	/**
	 * Use Map and Edit Grid Insert,Update,Delete
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/saveCommissionItemGrid.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> saveCommissionItemGrid(@RequestBody Map<String, ArrayList<Object>> params, Model model,SessionVO sessionVO) {

		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);

		String loginId = String.valueOf(sessionVO.getUserId());

		List<Object> udtList = params.get(AppConstants.AUIGRID_UPDATE); 	// Get gride UpdateList
		List<Object> addList = params.get(AppConstants.AUIGRID_ADD); 		// Get grid addList
		List<Object> delList = params.get(AppConstants.AUIGRID_REMOVE);  // Get grid DeleteList

		int cnt = 0;
		String msg= "";
		if (addList.size() > 0) {
			msg = commissionSystemService.addCommissionItemGrid(addList,loginId);
		}
		if (udtList.size() > 0) {
			msg = commissionSystemService.udtCommissionItemGrid(udtList,loginId);
		}
		/*if (delList.size() > 0) {
			cnt = commissionSystemService.delCommissionGrid(delList,loginId);
		}*/

		logger.info("수정 : {}", udtList.toString());
		logger.info("추가 : {}", addList.toString());
		//logger.info("삭제 : {}", delList.toString());
		logger.info("카운트 : {}", cnt);

		message.setMessage(msg);

		return ResponseEntity.ok(message);
	}

	/**
	 * Use Map and Edit Grid Insert,Update,Delete
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/saveCommissionRule.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> saveCommissionRuleData(@RequestBody Map<String, Object> params, Model model,SessionVO sessionVO) {

		String loginId = String.valueOf(sessionVO.getUserId());

		String saveType = params.get("saveType")==null?"I":String.valueOf(params.get("saveType"));

		int cnt = 0;
		int uCnt=0;
		if (saveType.equals("U")) {
			uCnt=commissionSystemService.cntUpdateDate(params);

			if(uCnt > 0){
				commissionSystemService.udtCommissionRuleData(params);
			}else{
				cnt = commissionSystemService.udtCommissionRuleData(params,loginId);
			}
		}else{
			cnt = commissionSystemService.addCommissionRuleData(params,loginId);
		}

		// 결과 만들기 예.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}

	/**
	 * Search rule book Item management list
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectRuleBookMngList", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectRuleBookMngList(@RequestParam Map<String, Object> params, ModelMap model) {

		String dt = String.valueOf(params.get("searchDt"));
		if (dt.trim().equals("")) {
			dt = CommonUtils.getNowDate().substring(0, 6);
			params.put("searchDt", dt);
		} else if (dt.contains("/")) {
			dt = dt.replaceAll("/", "");
			dt = dt.substring(2) + dt.substring(0, 2);
			params.put("searchDt", dt);
		}

		List<EgovMap> ruleBookMngList = commissionSystemService.selectRuleBookMngList(params);

		// return data
		return ResponseEntity.ok(ruleBookMngList);
	}

	/**
	 * Search rule book Item info
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectRuleBookInfo", method = RequestMethod.GET)
	public ResponseEntity<Map> selectRuleBookInfo(@RequestParam Map<String, Object> params, ModelMap model) {

		String dt = String.valueOf(params.get("searchDt"));
		if (dt.trim().equals("")) {
			dt = CommonUtils.getNowDate().substring(0, 6);
			params.put("searchDt", dt);
		} else if (dt.contains("/")) {
			dt = dt.replaceAll("/", "");
			dt = dt.substring(2) + dt.substring(0, 2);
			params.put("searchDt", dt);
		}


		List<EgovMap> ruleBookMngList = commissionSystemService.selectRuleBookMngList(params);
		params.put("mstId", CommissionConstants.COMIS_TYPE_CD);
		List<EgovMap> ruleValueList = commissionSystemService.selectRuleValueType(params);

		Map<String, Object> map= new HashMap<String, Object>();
		map.put("typeList", ruleValueList);
		map.put("ruleList", ruleBookMngList);

		// return data
		return ResponseEntity.ok(map);
	}

	/**
	 * Call Weekly  management
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/weeklyCommissionMng.do")
	public String weeklyCommissionMng(@RequestParam Map<String, Object> params, ModelMap model) {

		String dt = CommonUtils.getNowDate().substring(0, 6);
		dt = dt.substring(4) + "/" + dt.substring(0, 4);

		model.addAttribute("searchDt", dt);
		model.addAttribute("year",  Integer.parseInt(dt.substring(3)));
		model.addAttribute("month", Integer.parseInt(dt.substring(0,2)));

		// 호출될 화면
		return "commission/commissionWeeklyMng";
	}

	/**
	 * Weekly Ajax Search
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectWeeklyList", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectWeeklyList(@RequestParam Map<String, Object> params, ModelMap model) {

		// 조회.
		List<EgovMap> weeklyList = commissionSystemService.selectWeeklyList(params);

		// 데이터 리턴.
		return ResponseEntity.ok(weeklyList);
	}

	/**
	 * Weekly  management
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/saveCommissionWeeklyGrid.do", method = RequestMethod.POST)
	public  ResponseEntity<ReturnMessage>  saveCommissionWeeklyGrid(@RequestBody Map<String, ArrayList<Object>> params, Model model,SessionVO sessionVO) {

		String dt = CommonUtils.getNowDate().substring(0, 6);
		dt = dt.substring(4) + "/" + dt.substring(0, 4);

		String loginId = String.valueOf(sessionVO.getUserId());

		List<Object> udtList = params.get(AppConstants.AUIGRID_UPDATE); 	// Get gride UpdateList
		List<Object> addList = params.get(AppConstants.AUIGRID_ADD); 		// Get grid addList

		int cnt = 0;

		if (addList.size() > 0) {
			cnt = commissionSystemService.addWeeklyCommissionGrid(addList, loginId);
		}
		if (udtList.size() > 0) {
			cnt = commissionSystemService.udtWeeklyCommissionGrid(udtList,loginId);
		}

		model.addAttribute("searchDt", dt);
		model.addAttribute("year",  Integer.parseInt(dt.substring(3)));
		model.addAttribute("month", Integer.parseInt(dt.substring(0,2)));

		logger.info("수정 : {}", udtList.toString());
		logger.info("추가 : {}", addList.toString());
		//logger.info("삭제 : {}", delList.toString());
		logger.info("카운트 : {}", cnt);

		// 결과 만들기 예.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		return ResponseEntity.ok(message);
	}

	/**
	 * rule book actual / simulation version management pop
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/commissionRuleVersionMng.do")
	public String commissionRuleVersionMng(@RequestParam Map<String, Object> params, ModelMap model) {

		params.put("mstId", CommissionConstants.COMIS_EMP_CD);
		List<EgovMap> orgGrList = commissionSystemService.selectOrgGrList(params);
		model.addAttribute("orgGrList", orgGrList);
		params.put("mstId", CommissionConstants.COMIS_CD_CD);
		List<EgovMap> orgList = commissionSystemService.selectOrgList(params);
		String dt = CommonUtils.getNowDate().substring(0, 6);
		dt = dt.substring(4) + "/" + dt.substring(0, 4);

		model.addAttribute("searchDt", dt);
		model.addAttribute("orgGrList", orgGrList);
		model.addAttribute("orgList", orgList);
		// 호출될 화면
		return "commission/commissionRuleVersionManagement";
	}

	/**
	 * select actual / simulation version list
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/selectVersionList", method = RequestMethod.GET)
	public ResponseEntity<Map> selectVersionList(@RequestParam Map<String, Object> params, ModelMap model) {

		String dt = String.valueOf(params.get("searchDt"));
		if (dt.trim().equals("")) {
			dt = CommonUtils.getNowDate().substring(0, 6);
			params.put("searchDt", dt);
		} else if (dt.contains("/")) {
			dt = dt.replaceAll("/", "");
			dt = dt.substring(2) + dt.substring(0, 2);
			params.put("searchDt", dt);
		}

		List<EgovMap> actualList = commissionSystemService.selectRuleBookItemMngList(params);
		List<EgovMap> simulList = commissionSystemService.selectSimulationMngList(params);


		Map<String, Object> map= new HashMap<String, Object>();
		map.put("actualList", actualList);
		map.put("simulList", simulList);

		// return data
		return ResponseEntity.ok(map);
	}

	/**
	 * version simulation rule book / item insert
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/saveCommVersionInsert.do", method = RequestMethod.POST)
	//public  ResponseEntity<ReturnMessage>  saveCommVersionInsert(@RequestBody Map<String, ArrayList<Object>> params, Model model) {
	public  ResponseEntity<ReturnMessage>  saveCommVersionInsert(@RequestBody Map<String, Object> params, Model model,SessionVO sessionVO) {

		String dt = CommonUtils.getNowDate().substring(0, 6);
		dt = dt.substring(4) + "/" + dt.substring(0, 4);

		String loginId = String.valueOf(sessionVO.getUserId());

		Map<String, Object> formMap = (Map<String, Object>) params.get(AppConstants.AUIGRID_FORM);
		List<Object> simulList = (List<Object>)params.get(AppConstants.AUIGRID_ALL); 	// Get grid addList
		formMap.put("loginId", loginId);

		commissionSystemService.versionItemInsert(formMap,simulList);

		// 결과 만들기 예.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		return ResponseEntity.ok(message);
	}


	/**
	 * simulation valid search
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/varsionVaildSearch", method = RequestMethod.GET)
	public ResponseEntity<String> varsionVaildSearch(@RequestParam Map<String, Object> params, ModelMap model) {
		String itemSeq = itemSeq=  commissionSystemService.varsionVaildSearch(params.get("itemCd").toString());

		return ResponseEntity.ok(itemSeq);
	}

	 @RequestMapping(value = "/commissionWeeklyMgmtRawPop.do")
	 public String commissionWeeklyMgmtRawPop(@RequestParam Map<String, Object> params, ModelMap model) {
	   String dt = CommonUtils.getNowDate().substring(0, 6);
       dt = dt.substring(4) + "/" + dt.substring(0, 4);
       SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
       params.put("userId", sessionVO.getUserId());

       if( sessionVO.getUserTypeId() == 1){
           EgovMap getUserInfo = salesCommonService.getUserInfo(params);
           model.put("memType", getUserInfo.get("memType"));
           model.put("orgCode", getUserInfo.get("orgCode"));
           model.put("grpCode", getUserInfo.get("grpCode"));
           model.put("deptCode", getUserInfo.get("deptCode"));
           model.put("memCode", getUserInfo.get("memCode"));
           logger.info("memType ##### " + getUserInfo.get("memType"));
       }

       model.addAttribute("searchWSDt", dt);

	   return "commission/commissionWeeklyMgmtRawPop";
	 }

	  @RequestMapping(value = "/selectHPDeptCodeListByLv", method = RequestMethod.GET)
	    public ResponseEntity<List<EgovMap>> selectHPDeptCodeListByLv( @RequestParam Map<String, Object> params,HttpServletRequest request, ModelMap model) {

	    logger.debug("selectHPDeptCodeListByLv - params : " + params);
	        List<EgovMap>selectHMDeptCodeList = commissionSystemService.selectHPDeptCodeListByLv(params);

	        return ResponseEntity.ok(selectHMDeptCodeList);
	    }

	   @RequestMapping(value = "/selectHPDeptCodeListByCode", method = RequestMethod.GET)
       public ResponseEntity<List<EgovMap>> selectHPDeptCodeListByCode( @RequestParam Map<String, Object> params,HttpServletRequest request, ModelMap model) {

       logger.debug("selectHPDeptCodeListByCode - params : " + params);
           List<EgovMap>selectHMDeptCodeList = commissionSystemService.selectHPDeptCodeListByCode(params);

           return ResponseEntity.ok(selectHMDeptCodeList);
       }

}
