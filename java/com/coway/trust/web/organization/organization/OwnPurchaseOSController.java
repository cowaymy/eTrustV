package com.coway.trust.web.organization.organization;

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
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.biz.organization.organization.OwnPurchaseOSService;
import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/organization/ownPurchase")
public class OwnPurchaseOSController {

    private static final Logger LOGGER = LoggerFactory.getLogger(OwnPurchaseOSController.class);

    @Resource(name = "OwnPurchaseOSService")
    private OwnPurchaseOSService ownPurchaseOSService;

    @Autowired
    private MessageSourceAccessor messageAccessor;

    @RequestMapping(value = "/ownPurchasOSList.do")
    public String ownPurchasOSList(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {
        if(sessionVO.getUserTypeId() != 4 && sessionVO.getUserTypeId() != 6) {
            params.put("userId", sessionVO.getUserId());
            EgovMap orgDtls = (EgovMap) ownPurchaseOSService.getOrgDtls(params);

            model.addAttribute("memCode", (String) orgDtls.get("memCode"));
            model.addAttribute("orgCode", (String) orgDtls.get("orgCode"));
            model.addAttribute("grpCode", (String) orgDtls.get("grpCode"));
            model.addAttribute("deptCode", (String) orgDtls.get("deptCode"));

        } else if(sessionVO.getUserTypeId() == 4) {
            params.put("userId", sessionVO.getUserId());
            EgovMap orgDtls = (EgovMap) ownPurchaseOSService.getOrgDtls(params);

            model.addAttribute("memCode", (String) orgDtls.get("memCode"));
        }

        return "organization/organization/ownPurchaseOSList";
    }

    @RequestMapping(value = "/searchOwnPurchase.do", method = RequestMethod.GET)
    public ResponseEntity<List<EgovMap>> searchOwnPurchase(@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model, SessionVO sessionVO) {
        LOGGER.debug("ownPurchase :: searchOwnPurchase");

        List<EgovMap> list = ownPurchaseOSService.searchOwnPurchase(params);
        return ResponseEntity.ok(list);
    }
}
