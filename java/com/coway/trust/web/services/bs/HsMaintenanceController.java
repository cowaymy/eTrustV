/**
 *
 */
package com.coway.trust.web.services.bs;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.common.CommonService;
import com.coway.trust.biz.sales.common.SalesCommonService;
import com.coway.trust.biz.services.bs.HsAccConfigService;
import com.coway.trust.biz.services.bs.HsMaintenanceService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.web.sales.SalesConstants;
import com.crystaldecisions.jakarta.poi.util.StringUtil;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @author HQIT-HUIDING
 * @date Jul 20, 2020
 *
 */

@Controller
@RequestMapping(value="/services/hs")
public class HsMaintenanceController {
	private static final Logger logger = LoggerFactory.getLogger(HsMaintenanceController.class);

	@Resource(name = "hsAccConfigService")
	private HsAccConfigService hsAccConfigService;

	@Resource(name = "hsMaintenanceService")
	private HsMaintenanceService hsMaintenanceService;

	@Resource(name = "commonService")
	private CommonService commonService;

	@Resource(name = "salesCommonService")
	private SalesCommonService salesCommonService;


	@RequestMapping(value="/initHsMaintenanceList.do")
	public String initHsMaintenanceList(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO){

		String dayFrom = "26"; // default 26-{month-1}
		String dayTo = "05"; // default 5-{month}

		logger.debug("getUserBranchId : {}", sessionVO.getUserBranchId());

	    params.put("memberLevel", sessionVO.getMemberLevel());
	    params.put("userName", sessionVO.getUserName());
	    params.put("userType", sessionVO.getUserTypeId());

	    logger.debug("=======================================================================================");
	    logger.debug("============== initHsMaintenanceList params{} ", params);
	    logger.debug("=======================================================================================");

	    List<EgovMap> branchList = hsAccConfigService.selectBranchList(params);
	    model.addAttribute("branchList", branchList);

	    model.addAttribute("userName", sessionVO.getUserName());

	    model.addAttribute("memberLevel", sessionVO.getMemberLevel());
	    model.addAttribute("userType", sessionVO.getUserTypeId());
	    // model.addAttribute("userType","3");

	    String bfDay = CommonUtils.changeFormat(CommonUtils.getCalMonth(-1), SalesConstants.DEFAULT_DATE_FORMAT3,
	        SalesConstants.DEFAULT_DATE_FORMAT1);
	    String toDay = CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT1);

	    /* Added for blocking HS maintenance update between specified period by Hui Ding, 2020-09-09 **/
	    logger.info("###bfDay: " + bfDay);
	    logger.info("###toDay: " + toDay);

	    Map<String, Object> blockParams = new HashMap<String, Object>();
	    blockParams.put("groupCode", 456);
	   // blockParams.put("codeIn", "DAY_FROM");

	    List<EgovMap> blockDtList = commonService.selectCodeList(blockParams);
	    if (blockDtList != null && !blockDtList.isEmpty()){
	    	for (int i = 0; i < blockDtList.size(); i++){
	    		EgovMap blockDt = blockDtList.get(i);
	    		if (blockDt.get("code")!= null ){
	    			if (blockDt.get("code").toString().equalsIgnoreCase("DAY_FROM")){
	    				dayFrom = blockDt.get("codeName").toString();
	    			} else {
	    				dayTo = blockDt.get("codeName").toString();
	    			}
	    		}
	    	}
	    }

	    params.put("userId", sessionVO.getUserId());

	    if( sessionVO.getUserTypeId() == 1 || sessionVO.getUserTypeId() == 2 || sessionVO.getUserTypeId() == 7){
			EgovMap getUserInfo = salesCommonService.getUserInfo(params);
			model.put("memType", getUserInfo.get("memType"));
			model.put("orgCode", getUserInfo.get("orgCode"));
			model.put("grpCode", getUserInfo.get("grpCode"));
			model.put("deptCode", getUserInfo.get("deptCode"));
			model.put("memCode", getUserInfo.get("memCode"));
			logger.info("memType ##### " + getUserInfo.get("memType"));
		}

	    model.put("hsBlockDtFrom", dayFrom);
	    model.put("hsBlockDtTo", dayTo);
	    /* Ended for blocking HS maintenance update between specified period by Hui Ding, 2020-09-09 **/
	    model.put("bfDay", bfDay);
	    model.put("toDay", toDay);


	    return "services/bs/hsMaintenanceList";

	}

	@RequestMapping(value = "/selectCurrMonthHsList.do")
	public ResponseEntity<List<EgovMap>> getCurrMonthHsList (@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model, SessionVO sessionVO) {

		params.put("user_id", sessionVO.getUserId());
	    params.put("userType", sessionVO.getUserTypeId());

	    logger.debug("###userType :  " + sessionVO.getUserTypeId());

	    // get current month Hs config details
	    List<EgovMap> currMthHsConfigList = hsMaintenanceService.selectCurrMonthHsList(params);

	    return ResponseEntity.ok(currMthHsConfigList);
	}

	@RequestMapping(value = "/selectTrfCody.do")
	  public String selecthSCodyChangePop(@RequestParam Map<String, Object> params, HttpServletRequest request,
	      ModelMap model, SessionVO sessionVO) {

	    logger.debug("###selectTrfCody params : {}", params);

	    model.addAttribute("brnchCdList", params.get("BrnchId"));
	    model.addAttribute("ordCdList", params.get("CheckedItems"));
	    model.addAttribute("ManuaMyBSMonth", params.get("ManuaMyBSMonth"));
	    model.addAttribute("deptList", params.get("deptList"));

	    return "services/bs/hsTrfCodyPop";
	  }

	 @RequestMapping(value = "/assignTrfCodyListSave.do", method = RequestMethod.POST)
	  public ResponseEntity<ReturnMessage> assignCDChangeListSave(@RequestBody Map<String, Object> params, Model model,
	      HttpServletRequest request, SessionVO sessionVO) {

	    logger.debug("in  assignTrfCodyListSave ");
	    logger.debug("			pram set  log");
	    logger.debug("					" + params.toString());
	    logger.debug("			pram set end  ");

	    params.put("updator", sessionVO.getUserId());
	    List<EgovMap> update = (List<EgovMap>) params.get("update");
	    logger.debug("HSResultM ===>" + update.toString());

	    String rtnValue = hsMaintenanceService.updateAssignCodyBulk(params);

	    ReturnMessage message = new ReturnMessage();
	    message.setCode(AppConstants.SUCCESS);
	    message.setData(99);
	    message.setMessage(rtnValue);

	    return ResponseEntity.ok(message);

	  }

}
