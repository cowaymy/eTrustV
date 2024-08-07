package com.coway.trust.web.logistics.agreement;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.poi.openxml4j.exceptions.InvalidFormatException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.csv.CsvReadComponent;
import com.coway.trust.AppConstants;
import com.coway.trust.biz.logistics.agreement.AgreementUploadVO;
import com.coway.trust.biz.logistics.agreement.agreementService;
import com.coway.trust.biz.organization.organization.MemberListService;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/logistics")
public class AgreementController {

    @Resource(name = "agreementService")
    private agreementService agreementService;

    @Resource(name = "memberListService")
    private MemberListService memberListService;

	@Autowired
	private CsvReadComponent csvReadComponent;

    private static final Logger logger = LoggerFactory.getLogger(AgreementController.class);

    @RequestMapping(value = "/agreement/agreementDL.do")
    public String agreementDL(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {

        logger.debug("==================== agreementDL.do ====================");

        logger.debug("userName :: " + sessionVO.getUserName());

        params.put("userId", sessionVO.getUserId());
        EgovMap userRole = memberListService.getUserRole(params);


        List<EgovMap> branch = agreementService.branch();

        String strUserRole = userRole.get("roleid").toString();
        logger.debug("strUserRole :: " + strUserRole);

        if("97".equals(strUserRole) || "98".equals(strUserRole) || "99".equals(strUserRole) || "100".equals(strUserRole) || // SO Branch
           "103".equals(strUserRole) || "104".equals(strUserRole) || "105".equals(strUserRole) || // DST Support
           "111".equals(strUserRole) || "112".equals(strUserRole) || "113".equals(strUserRole) || "114".equals(strUserRole) || "115".equals(strUserRole) || // HP, HM, SM, GM
           "166".equals(strUserRole) || "167".equals(strUserRole) || "261".equals(strUserRole) || // DST Planning
           "335".equals(strUserRole) || "336".equals(strUserRole) || "337".equals(strUserRole) // Sales Care
        ) { // HP
            params.put("userTypeId", "1");

        } else if("177".equals(strUserRole) || "179".equals(strUserRole) || "180".equals(strUserRole) || // Cody Support
                "200".equals(strUserRole) || "252".equals(strUserRole) || "253".equals(strUserRole) || // Cody Planning
                "250".equals(strUserRole) || "256".equals(strUserRole) ||  // Cody Branch
                "117".equals(strUserRole) || "118".equals(strUserRole) || "119".equals(strUserRole) || "120".equals(strUserRole) || "121".equals(strUserRole) // Cody Org
        ) { // CD
            params.put("userTypeId", "2");

        }else if("339".equals(strUserRole) || "343".equals(strUserRole) || "344".equals(strUserRole) || // Home Care
                "348".equals(strUserRole) || "349".equals(strUserRole) || "350".equals(strUserRole) || "351".equals(strUserRole) || "352".equals(strUserRole) // HT Org
        ) { // HT
            params.put("userTypeId", "7");

        }

        List<EgovMap> memLevel = agreementService.getMemLevel(params);

        model.addAttribute("userRole", userRole.get("roleid"));
        model.addAttribute("memType", userRole.get("memtype"));
        model.addAttribute("memCode", sessionVO.getUserName());
        model.addAttribute("branchList", branch);
        model.addAttribute("memLevel", memLevel);
        logger.debug("=================================== :: " + userRole.toString());
        model.addAttribute("userName", userRole.get("username"));
        model.addAttribute("userFullName", userRole.get("userfullname"));
        model.addAttribute("userNric", userRole.get("usernric"));

        EgovMap item = new EgovMap();
        item = (EgovMap) agreementService.getBranchCd(params);

        if(item != null) {
            if(item.get("branch") != null) {
                model.addAttribute("branch", item.get("branch"));
            }
        }

        return "logistics/Agreement/agreementList";
    }

    @RequestMapping(value = "/agreement/getMemberInfo", method = RequestMethod.GET)
    public ResponseEntity<Map> getMemberInfo(@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model) {

        logger.debug("==================== getMemberInfo ====================");

        Map<String, Object> memInfo = new HashMap();
        List<EgovMap> memberList = agreementService.memberList(params);
        memInfo.put("name", memberList.get(0).get("name"));
        memInfo.put("nric", memberList.get(0).get("nric"));
        memInfo.put("deptCode", memberList.get(0).get("deptcode"));
        memInfo.put("grpCode", memberList.get(0).get("grpcode"));
        memInfo.put("orgCode", memberList.get(0).get("orgcode"));
        memInfo.put("memLvl", memberList.get(0).get("memlvl"));
        memInfo.put("stus", memberList.get(0).get("stus"));
        memInfo.put("promoDt", memberList.get(0).get("promodt"));
        memInfo.put("cnfmDt", memberList.get(0).get("cnfmdt"));
        memInfo.put("joinDt", memberList.get(0).get("joindt"));
        memInfo.put("versionid", memberList.get(0).get("versionid"));
        memInfo.put("rptflnm", memberList.get(0).get("rptflnm"));

        return ResponseEntity.ok(memInfo);
    }

    @RequestMapping(value = "/agreement/memberList", method = RequestMethod.GET)
    public ResponseEntity<List<EgovMap>> memberList(@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model) {

        logger.debug("==================== memberList ====================");
        logger.debug("params of memberList :: {}", params);

        List<EgovMap> memberList = agreementService.memberList(params);

        return ResponseEntity.ok(memberList);
    }

    @RequestMapping(value = "/agreement/getMemStatus", method = RequestMethod.GET)
    public ResponseEntity<List<EgovMap>> getMemStatus(@RequestParam Map<String, Object> params) {

        logger.debug("==================== getMemStatus ====================");

        logger.debug("params {}", params);

        List<EgovMap> codeList = agreementService.getMemStatus(params);
        logger.debug("params {}", params);
        return ResponseEntity.ok(codeList);
    }

    @RequestMapping(value = "/agreement/getMemLevel", method = RequestMethod.GET)
    public ResponseEntity<List<EgovMap>> getMemLevel(@RequestParam Map<String, Object> params) {

        logger.debug("==================== getMemLevel ====================");

        logger.debug("params {}", params);

        List<EgovMap> codeList = agreementService.getMemLevel(params);
        return ResponseEntity.ok(codeList);
    }

    @RequestMapping(value = "/agreement/getAgreementVersion", method = RequestMethod.GET)
    public ResponseEntity<List<EgovMap>> getAgreementVersion(@RequestParam Map<String, Object> params) {

        logger.debug("==================== getAgreementVersion ====================");

        logger.debug("params {}", params);

        List<EgovMap> codeList = agreementService.getAgreementVersion(params);
        return ResponseEntity.ok(codeList);
    }

    @RequestMapping(value = "/agreement/getMemHPpayment", method = RequestMethod.GET)
    public ResponseEntity<Map> getMemHPpayment(@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model) {

        logger.debug("==================== getMemHPpayment ====================");

        logger.debug("params {}", params);

        Map<String, Object> memInfo = new HashMap();

        EgovMap item = new EgovMap();
        item = (EgovMap) agreementService.getMemHPpayment(params);
        memInfo.put("version", item.get("version"));

        return ResponseEntity.ok(memInfo);
    }

    @RequestMapping(value = "/agreement/cdEagmt1", method = RequestMethod.GET)
    public ResponseEntity<Map> cdEagmt1(@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model) {

        logger.debug("==================== cdEagmt1 ====================");

        EgovMap item = new EgovMap();
        item = (EgovMap) agreementService.cdEagmt1(params);

        Map<String, Object> memInfo = new HashMap();
        memInfo.put("signdt", item.get("signdt"));

        return ResponseEntity.ok(memInfo);
    }

    @RequestMapping(value = "/agreement/prevAgreement.do", method = RequestMethod.GET)
    public ResponseEntity<Map> prevAgreement(@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model) {

        logger.debug("==================== prevAgreement ====================");
        logger.debug("params {}", params);

        Map<String, Object> agreementInfo = new HashMap();

        EgovMap item = new EgovMap();
        item = (EgovMap) agreementService.prevAgreement(params);
        agreementInfo.put("cnfmDt", item.get("cnfmDt"));
        agreementInfo.put("version", item.get("versionId"));
        agreementInfo.put("rptFileNm", item.get("fileName"));

        return ResponseEntity.ok(agreementInfo);
    }

    @RequestMapping(value = "/agreement/checkConsent.do", method = RequestMethod.GET)
    public ResponseEntity<ReturnMessage> checkConsent(@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model, SessionVO session) {
        logger.debug("loginController :: tempPwProcess");
        logger.debug("params : {}", params);

//        Map<String, Object> consentMap = new HashMap<String, Object>();
        int consent = agreementService.checkConsent(params);

        ReturnMessage message = new ReturnMessage();
        if(consent > 0) {
            message.setCode(AppConstants.SUCCESS);
        } else {
            message.setCode(AppConstants.FAIL);
        }

        return ResponseEntity.ok(message);
    }

    @RequestMapping(value = "/agreement/consentList.do", method = RequestMethod.GET)
    public ResponseEntity<List<EgovMap>> consentList(@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model) {

        logger.debug("==================== consentList ====================");
        logger.debug("params of memberList :: {}", params);

        List<EgovMap> memberList = agreementService.consentList(params);

        return ResponseEntity.ok(memberList);
    }

    @RequestMapping(value = "/agreement/eAgreementHistoryList.do")
    public String eAgreementHistoryList(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {
        params.put("userId", sessionVO.getUserId());
        EgovMap userRole = memberListService.getUserRole(params);


        List<EgovMap> branch = agreementService.branch();

        String strUserRole = userRole.get("roleid").toString();
        logger.debug("strUserRole :: " + strUserRole);

        if("97".equals(strUserRole) || "98".equals(strUserRole) || "99".equals(strUserRole) || "100".equals(strUserRole) || // SO Branch
           "103".equals(strUserRole) || "104".equals(strUserRole) || "105".equals(strUserRole) || // DST Support
           "111".equals(strUserRole) || "112".equals(strUserRole) || "113".equals(strUserRole) || "114".equals(strUserRole) || "115".equals(strUserRole) || // HP, HM, SM, GM
           "166".equals(strUserRole) || "167".equals(strUserRole) || "261".equals(strUserRole) || // DST Planning
           "335".equals(strUserRole) || "336".equals(strUserRole) || "337".equals(strUserRole) // Sales Care
        ) { // HP
            params.put("userTypeId", "1");

        } else if("177".equals(strUserRole) || "179".equals(strUserRole) || "180".equals(strUserRole) || // Cody Support
                "200".equals(strUserRole) || "252".equals(strUserRole) || "253".equals(strUserRole) || // Cody Planning
                "250".equals(strUserRole) || "256".equals(strUserRole) ||  // Cody Branch
                "117".equals(strUserRole) || "118".equals(strUserRole) || "119".equals(strUserRole) || "120".equals(strUserRole) || "121".equals(strUserRole) // Cody Org
        ) { // CD
            params.put("userTypeId", "2");

        }else if("339".equals(strUserRole) || "343".equals(strUserRole) || "344".equals(strUserRole) || // Home Care
                "348".equals(strUserRole) || "349".equals(strUserRole) || "350".equals(strUserRole) || "351".equals(strUserRole) || "352".equals(strUserRole) // HT Org
        ) { // HT
            params.put("userTypeId", "7");

        }

        List<EgovMap> memLevel = agreementService.getMemLevel(params);

        model.addAttribute("userRole", userRole.get("roleid"));
        model.addAttribute("memType", userRole.get("memtype"));
        model.addAttribute("memCode", sessionVO.getUserName());
        model.addAttribute("branchList", branch);
        model.addAttribute("memLevel", memLevel);
        logger.debug("=================================== :: " + userRole.toString());
        model.addAttribute("userName", userRole.get("username"));
        model.addAttribute("userFullName", userRole.get("userfullname"));
        model.addAttribute("userNric", userRole.get("usernric"));

        EgovMap item = new EgovMap();
        item = (EgovMap) agreementService.getBranchCd(params);

        if(item != null) {
            if(item.get("branch") != null) {
                model.addAttribute("branch", item.get("branch"));
            }
        }

        return "misc/eAgreement/eAgreementHistoryList";
    }

    @RequestMapping(value = "/agreement/selectEAgreementHistoryList.do", method = RequestMethod.GET)
    public ResponseEntity<List<EgovMap>> selectEAgreementHistoryList(@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model) {


        List<EgovMap> agreementHistoryList = agreementService.selectAgreementHistoryList(params);

        return ResponseEntity.ok(agreementHistoryList);
    }

    @RequestMapping(value = "/agreement/csvAgreementNamelistFileUpload.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> csvAgreementNamelistFileUpload(MultipartHttpServletRequest request, SessionVO sessionVO) throws IOException, InvalidFormatException {
    	ReturnMessage message = new ReturnMessage();

    	Map<String, MultipartFile> fileMap = request.getFileMap();
		MultipartFile multipartFile = fileMap.get("csvFile");
		List<AgreementUploadVO> vos = csvReadComponent.readCsvToList(multipartFile, true, AgreementUploadVO::create);

		List<Map<String, Object>> details = new ArrayList<Map<String, Object>>();

		for (AgreementUploadVO vo : vos) {
			HashMap<String, Object> hm = new HashMap<String, Object>();

			hm.put("memCode",vo.getMemCode().trim());
			details.add(hm);
		}

		if(details.size() > 0){
			message = agreementService.agreementNamelistUpload(details, sessionVO);
		}
		else{
			message.setCode(AppConstants.FAIL);
			message.setMessage("No data found");
		}
		return ResponseEntity.ok(message);
    }
}
