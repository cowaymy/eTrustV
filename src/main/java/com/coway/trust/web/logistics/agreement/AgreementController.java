package com.coway.trust.web.logistics.agreement;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.cmmn.model.SessionVO;
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
           "111".equals(strUserRole) || "112".equals(strUserRole) || "113".equals(strUserRole) || "114".equals(strUserRole) || "115".equals(strUserRole)) { // HP
            params.put("userTypeId", "1");

        } else if("177".equals(strUserRole) || "179".equals(strUserRole) || "180".equals(strUserRole) || // Cody Support
                "200".equals(strUserRole) || "252".equals(strUserRole) || "253".equals(strUserRole) || // Cody Planning
                "250".equals(strUserRole) || "256".equals(strUserRole) ||  // Cody Branch)
                "117".equals(strUserRole) || "118".equals(strUserRole) || "119".equals(strUserRole) || "120".equals(strUserRole) || "121".equals(strUserRole)) { // Cody
            params.put("userTypeId", "2");
        }else if("348".equals(strUserRole) || "349".equals(strUserRole) || "350".equals(strUserRole) || "351".equals(strUserRole) || // HT Manager
                "352".equals(strUserRole) ) { // HT
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

        EgovMap item = new EgovMap();
        item = (EgovMap) agreementService.getMemberInfo(params);

        Map<String, Object> memInfo = new HashMap();
        memInfo.put("name", item.get("name"));
        memInfo.put("nric", item.get("nric"));
        memInfo.put("deptCode", item.get("deptcde"));
        memInfo.put("grpCode", item.get("grpcde"));
        memInfo.put("orgCode", item.get("orgcde"));
        memInfo.put("memLvl", item.get("memlvl"));
        memInfo.put("stus", item.get("stus"));
        memInfo.put("signDt", item.get("cnfmdt"));
        memInfo.put("promoDt", item.get("promoDt"));
        memInfo.put("cnfmDt", item.get("cdCnfmDt"));
        memInfo.put("joinDt", item.get("joinDt"));

        // getMemHPpayment
        if("1".equals(params.get("memType"))) {
            EgovMap item2 = new EgovMap();
            item2 = (EgovMap) agreementService.getMemHPpayment(params);
            memInfo.put("version", item2.get("version"));
        }

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
}
