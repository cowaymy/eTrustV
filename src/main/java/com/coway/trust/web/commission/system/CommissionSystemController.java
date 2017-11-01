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
	public ResponseEntity<ReturnMessage> saveCommissionGrid(@RequestBody Map<String, ArrayList<Object>> params, Model model) {

		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
		String loginId = "";
		if(sessionVO==null){
			loginId="1000000000";			
		}else{
			loginId=String.valueOf(sessionVO.getUserId());
		}
		
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
		
		List<EgovMap> orgList = commissionSystemService.selectOrgCdListAll(params);
		
		String dt = CommonUtils.getNowDate().substring(0, 6);
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
	public ResponseEntity<ReturnMessage> saveCommissionItemGrid(@RequestBody Map<String, ArrayList<Object>> params, Model model) {

		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);

		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
		String loginId = "";
		if(sessionVO==null){
			loginId="1000000000";			
		}else{
			loginId=String.valueOf(sessionVO.getUserId());
		}
		
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
	public ResponseEntity<ReturnMessage> saveCommissionRuleData(@RequestBody Map<String, Object> params, Model model) {

		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
		String loginId = "";
		if(sessionVO==null){
			loginId="1000000000";			
		}else{
			loginId=String.valueOf(sessionVO.getUserId());
		}
		
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
	public  ResponseEntity<ReturnMessage>  saveCommissionWeeklyGrid(@RequestBody Map<String, ArrayList<Object>> params, Model model) {

		String dt = CommonUtils.getNowDate().substring(0, 6);	
		dt = dt.substring(4) + "/" + dt.substring(0, 4);

		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
		String loginId = "";
		if(sessionVO==null){
			loginId="1000000000";			
		}else{
			loginId=String.valueOf(sessionVO.getUserId());
		}
		
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
	
	@RequestMapping(value = "/saveCommVersionInsert.do", method = RequestMethod.POST)
	//public  ResponseEntity<ReturnMessage>  saveCommVersionInsert(@RequestBody Map<String, ArrayList<Object>> params, Model model) {
	public  ResponseEntity<ReturnMessage>  saveCommVersionInsert(@RequestBody Map<String, Object> params, Model model) {

		String dt = CommonUtils.getNowDate().substring(0, 6);	
		dt = dt.substring(4) + "/" + dt.substring(0, 4);

		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
		String loginId = "";
		if(sessionVO==null){
			loginId="1000000000";
		}else{
			loginId=String.valueOf(sessionVO.getUserId());
		}
		
		Map<String, Object> formMap = (Map<String, Object>) params.get(AppConstants.AUIGRID_FORM);
		List<Object> simulList = (List<Object>)params.get(AppConstants.AUIGRID_ALL); 	// Get grid addList
		
		System.out.println(formMap);
		System.out.println(simulList);
		
		Map map = new HashMap();
		map.put("loginId",loginId);
		map.put("endDt",CommissionConstants.COMIS_END_DT);
		formMap.put("endDt",CommissionConstants.COMIS_END_DT);
		formMap.put("loginId",loginId);
		commissionSystemService.udtVersionItemEndDt(formMap);
		commissionSystemService.udtCommVersionRuleEndDt(map);
		
		
		if(simulList.size() > 0){
			for (Object obj : simulList) {
				Map sMap = (HashMap<String, Object>) obj;
				if( !("N".equals(sMap.get("newYn"))) ){
    				sMap.put("loginId", loginId);
    				sMap.put("endDt", CommissionConstants.COMIS_END_DT);
    				//new item Data All insert
					commissionSystemService.versionItemInsert(sMap);
				}
			}
			
			//select valid simulation all list 
			List<EgovMap> itemList = commissionSystemService.selectSimulationMngList(map);
			
			String searchDt = formMap.get("searchDt").toString();
			searchDt =  searchDt.substring(searchDt.indexOf("/")+1,searchDt.length())+searchDt.substring(0,searchDt.indexOf("/"));
			System.out.println(" %% searchDt : "+searchDt);
			//simulation item rule book save
			if(itemList.size() > 0){
				Map rMap = null; 
				for(int i=0 ; i< itemList.size() ; i++){
					rMap =  new HashMap();
					
					rMap.put("itemCd", itemList.get(i).get("itemCd"));
					rMap.put("endDt", CommissionConstants.COMIS_END_DT);
					rMap.put("searchDt", searchDt);
					
					List<EgovMap> ruleList = commissionSystemService.selectVersionRuleBookList(rMap);
					/*System.out.println("##############################");
					System.out.println(ruleList);
					System.out.println("##############################");*/
					
					if( ruleList.size() > 0 ){
						Map ruleMap = null;
						for(int j =0 ; j < ruleList.size() ; j ++){
							ruleMap = new HashMap();
							
							//String rulePid= sertchRulePid(ruleList,ruleList.get(i).get("ruleSeq").toString());
    						ruleMap.put("itemSeq", itemList.get(i).get("itemSeq"));
    						ruleMap.put("itemCd", ruleList.get(j).get("itemCd"));
    						ruleMap.put("ruleLevel", ruleList.get(j).get("ruleLevel"));
    						ruleMap.put("ruleSeq", ruleList.get(j).get("newSeq"));
    						//ruleMap.put("rulePid", ruleList.get(j).get("rulePid"));
    						ruleMap.put("rulePid", sertchRulePid(ruleList,ruleList.get(j).get("rulePid").toString()));
    						ruleMap.put("ruleNm", ruleList.get(j).get("ruleNm"));
    						ruleMap.put("ruleCategory", ruleList.get(j).get("ruleCategory"));
    						ruleMap.put("ruleOpt1", ruleList.get(j).get("ruleOpt1"));
    						ruleMap.put("ruleOpt2", ruleList.get(j).get("ruleOpt2"));
    						ruleMap.put("valueType", ruleList.get(j).get("valueType"));
    						ruleMap.put("valueTypeNm", ruleList.get(j).get("valueTypeNm"));
    						ruleMap.put("resultValue", ruleList.get(j).get("resultValue"));
    						ruleMap.put("resultValueNm", ruleList.get(j).get("resultValueNm"));
    						ruleMap.put("ruleDesc", ruleList.get(j).get("ruleDesc"));
    						ruleMap.put("startYearmonth", ruleList.get(j).get("startYearmonth"));
    						ruleMap.put("endYearmonth", ruleList.get(j).get("endYearmonth"));
    						ruleMap.put("useYn", ruleList.get(j).get("useYn"));
    						ruleMap.put("crtUserId", loginId);
    						ruleMap.put("updUserId", loginId);
    						ruleMap.put("prtOrder", ruleList.get(j).get("prtOrder"));
    						
    						commissionSystemService.addCommVersionRuleData(ruleMap);
						}
					}
				}
			}
		}

		// 결과 만들기 예.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		return ResponseEntity.ok(message);
	}
	
	@RequestMapping(value = "/varsionVaildSearch", method = RequestMethod.GET)
	public ResponseEntity<String> varsionVaildSearch(@RequestParam Map<String, Object> params, ModelMap model) {
		String itemSeq = itemSeq=  commissionSystemService.varsionVaildSearch(params.get("itemCd").toString());
		
		return ResponseEntity.ok(itemSeq);
	}
	
	public String sertchRulePid(List<EgovMap> list, String pid){
		String rulePid="0";
		System.out.println("***************pid : " +  pid);
		for(int i = 0; i < list.size() ; i++){
			if( !( "0".equals(pid) ) ){
				if( pid.equals(list.get(i).get("ruleSeq").toString()) ){
					rulePid = list.get(i).get("newSeq").toString();
					break;
				}
			}
		}
		
		return rulePid; 
	}

}
