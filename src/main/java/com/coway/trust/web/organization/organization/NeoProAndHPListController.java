package com.coway.trust.web.organization.organization;

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

import com.coway.trust.biz.organization.organization.MemberRawDataService;
import com.coway.trust.biz.organization.organization.NeoProAndHPListService;
import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/organization")
public class NeoProAndHPListController {

    private static final Logger logger = LoggerFactory.getLogger(MemberRawDataController.class);

    @Resource(name = "neoProAndHPListService")
    private NeoProAndHPListService neoProAndHPListService;

    @RequestMapping(value = "/initNeoProAndHPList.do")
    public String initNeoProAndHPList(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {

        model.addAttribute("userName", sessionVO.getUserName());
        model.addAttribute("userRole", sessionVO.getRoleId());
        model.addAttribute("userType", sessionVO.getUserTypeId());
        model.addAttribute("userLvl", sessionVO.getMemberLevel());

        return "organization/organization/neoProAndHPListing";
    }


    @RequestMapping(value = "/selectNeoProAndHPList.do", method = RequestMethod.GET)
    public ResponseEntity<List<EgovMap>> selectNeoProAndHPList(@RequestParam Map<String, Object>params, HttpServletRequest request, ModelMap model) {

        List<EgovMap> neoProAndHPList = null;

        neoProAndHPList = neoProAndHPListService.selectNeoProAndHPList(params);

        return ResponseEntity.ok(neoProAndHPList);
    }

    @RequestMapping(value = "/checkHpType.do")
    public ResponseEntity<Map> checkHpType(@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model) {

        EgovMap item = new EgovMap();

        item = neoProAndHPListService.checkHpType(params);
        Map<String, Object> mapInfo = new HashMap();
        if(item.get("hpType").toString() == "NEOPRO") {
            mapInfo.put("hpType", "1");
        } else {
            mapInfo.put("hpType", "0");
        }

        return ResponseEntity.ok(mapInfo);
    }
}
