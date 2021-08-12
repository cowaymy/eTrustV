package com.coway.trust.web.services.bs;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.biz.sample.SampleDefaultVO;
import com.coway.trust.biz.services.bs.BsResultAnalysisService;
import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/services/bs")
public class BsResultAnalysisController {

    private static Logger logger = LoggerFactory.getLogger(BsResultAnalysisController.class);

    @Resource(name = "bsResultAnalysisService")
    private BsResultAnalysisService bsResultAnalysisService;

    @RequestMapping(value = "/bsResultAnalysis.do")
    public String resultAnalysis(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {

        logger.debug("sessionVO :: UserID :::::::::::::::::::::::::::::::::::::::: " + sessionVO.getUserId());
        logger.debug("sessionVO :: memberlvl :::::::::::::::::::::::::::::::::::::::: " + sessionVO.getMemberLevel());

        params.put("userId", sessionVO.getUserId());

        EgovMap result = bsResultAnalysisService.getUserInfo(params);
        model.put("roleId", result.get("roleId"));
        model.put("memCode", result.get("memCode"));
        model.put("orgCode", result.get("lastOrgCode"));
        model.put("grpCode", result.get("lastGrpCode"));
        model.put("deptCode", result.get("deptCode"));
        model.put("memLvl", sessionVO.getMemberLevel());

        return "services/bs/bsResultAnalysis";
    }

    @RequestMapping(value = "/selectBsResultAnalysisList", method = RequestMethod.GET)
    public ResponseEntity<List<EgovMap>> selectResultAnalysisList(@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model, SessionVO sessionVO) {

        logger.debug("in selectResultAnalysisList");

        logger.debug("            param set  log");
        logger.debug("                    " + params.toString());
        logger.debug("            param set end  ");

        params.put("userId", sessionVO.getUserId());

        List<EgovMap> list = bsResultAnalysisService.selectAnalysisList(params);

        return ResponseEntity.ok(list);
    }

    @RequestMapping(value = "/selResultAnalysisByMember.do", method = RequestMethod.GET)
    public ResponseEntity<List<EgovMap>> selectMemberAnalysis(@ModelAttribute("searchVO") SampleDefaultVO searchVO, @RequestParam Map<String, Object> params, ModelMap model) {

        logger.debug("            pram set  log");
        logger.debug("                    " + params.toString());
        logger.debug("            pram set end  ");

        List<EgovMap> list = bsResultAnalysisService.selResultAnalysisByMember(params);

        return ResponseEntity.ok(list);
    }
}
