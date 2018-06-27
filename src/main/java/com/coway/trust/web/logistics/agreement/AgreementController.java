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

        model.addAttribute("userRole", userRole.get("roleid"));
        model.addAttribute("memType", userRole.get("memtype"));
        model.addAttribute("memCode", sessionVO.getUserName());

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

        List<EgovMap> memberList = agreementService.memberList(params);

        return ResponseEntity.ok(memberList);
    }

    @RequestMapping(value = "/agreement/getMemStatus", method = RequestMethod.GET)
    public ResponseEntity<List<EgovMap>> getMemStatus(@RequestParam Map<String, Object> params) {

        logger.debug("==================== getMemStatus ====================");

        logger.debug("params {}", params);

        List<EgovMap> codeList = agreementService.getMemStatus(params);
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
}
