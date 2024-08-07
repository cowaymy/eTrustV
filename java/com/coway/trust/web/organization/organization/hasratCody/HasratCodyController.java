/**
 *
 */
package com.coway.trust.web.organization.organization.hasratCody;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

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
import com.coway.trust.biz.organization.hasratCody.HasratCodyService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.handler.SessionHandler;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @author HQIT-HUIDING
 * @date Oct 13, 2020
 *
 */

@Controller
@RequestMapping(value = "/organization")
public class HasratCodyController {

	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	@Autowired
	private MessageSourceAccessor messageAccessor;

	@Value("${app.name}")
	private String appName;

	@Resource(name="hasratCodyService")
	private HasratCodyService hasratCodyService;

	@Autowired
	private SessionHandler sessionHandler;

	@RequestMapping(value = "/hasratCodyList.do")
	public String hasratCodyList(@RequestParam Map<String, Object> params, ModelMap model) {
		return "organization/organization/hasratCodyList";
	}
	/*public String hasratCodyList(Model model, HttpServletRequest request, HttpServletResponse response) throws Exception {
		return "organization/organization/hasratCodyList";
	}*/


	@RequestMapping(value = "/hasratCodySearchList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectHasratCodySearchList(@RequestParam Map<String, Object>params)
	      throws Exception {

		logger.info("###params: " + params.toString());

		List<EgovMap> list = hasratCodyService.selectHasratCodyList(params);

		return ResponseEntity.ok(list);
	}

	@RequestMapping(value = "/codyBranchList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectCodyBranchList(@RequestParam Map<String, Object> params){
		List<EgovMap> codeList = hasratCodyService.selectCodyBranchList(params);
	    return ResponseEntity.ok(codeList);
	}

	@RequestMapping(value = "/hasratCodyNewPop.do")
	public String newHasratCody(@RequestParam Map<String, Object>params, ModelMap model,  SessionVO sessionVO) {

		//model.addAttribute("actionType", "ADD");
		logger.info("###actionType: " + params.get("actionType"));
		logger.info("###id: " + params.get("id"));
		int loginId = sessionVO.getUserId();

		//if (params.get("actionType")!= null){

			Map<String, Object> map = new HashMap();
    		//map.put("actionType", params.get("actionType"));

			//if (params.get("actionType").toString().equalsIgnoreCase("ADD")) {

        		Map userParam = new HashMap<String, Object>();
        		userParam.put("loginId", loginId);
        		EgovMap userInfo = hasratCodyService.selectUserInfo(userParam);

        		if (userInfo != null){
            		logger.info("###user info: " + loginId + " | branch: " + userInfo.get("branch") + " | name: " + userInfo.get("username")  + " | userCode: " + userInfo.get("usercode") + " | loginContact : " + userInfo.get("contactno"));

            		map.put("defaultId", loginId);
            		map.put("defaultBranch", userInfo.get("branch") != null ? userInfo.get("branch").toString() : "");
            		map.put("defaultBranchId", userInfo.get("branchid") != null ? userInfo.get("branchid").toString() : "");
            		map.put("defaultName", userInfo.get("username") != null ? userInfo.get("username").toString() : "");
            		map.put("defaultUserId", userInfo.get("userid"));
            		map.put("defaultUserCode", userInfo.get("usercode") != null ? userInfo.get("usercode").toString() : "");
            		map.put("defaultContact", userInfo.get("contactno") != null ? userInfo.get("contactno").toString() : "");
            		map.put("defaultCmCode", userInfo.get("cmcode") != null ? userInfo.get("cmcode").toString() : "");
            		map.put("defaultScmCode", userInfo.get("scmcode") != null ? userInfo.get("scmcode").toString() : "");
            		map.put("defaultGcmCode", userInfo.get("gcmcode") != null ? userInfo.get("gcmcode").toString() : "");
        		}
    		//}
			model.addAttribute("userInfo", map);
		//}

		return "organization/organization/hasratCodyNewPop";
	}

	@RequestMapping(value = "/saveHasratCody", method = RequestMethod.GET)
	public ResponseEntity<ReturnMessage> saveHasratCody(@RequestParam Map<String, Object>params, HttpServletRequest request, ModelMap model ,SessionVO sessionVO)
	      throws Exception {

		params.put("user_id", sessionVO.getUserId());
		ReturnMessage message = new ReturnMessage();
		int proceed = 0;
		String returnMsg = AppConstants.SUCCESS;
		String returnCode = messageAccessor.getMessage(AppConstants.MSG_SUCCESS);

		logger.info("###params: " + params.toString());

		if (params.get("actionType") != null){
			if (params.get("actionType").toString().equalsIgnoreCase("ADD")){

				try {
    				// insert new record
    				hasratCodyService.insertHasratCody(params);
    				proceed++;

        			if (proceed > 0) {
        				// send email
        				boolean sendEmail = hasratCodyService.sendContentEmail(params);

        				if (!sendEmail){
        					returnCode = AppConstants.FAIL;
        					returnMsg = "Fail to send email!";
        				}
        			}  else {
        				returnCode = AppConstants.FAIL;
    					returnMsg = "Fail to save.";

    				}
				} catch (Exception e){
					throw e;
				}

			} else {
				// update existing record
				// do nothing
			}
			message.setCode(returnMsg);
			message.setMessage(returnCode);
		}

		return ResponseEntity.ok(message);
	}
}


