package com.coway.trust.web.test;

import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.web.organization.organization.MemberListController;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/test")
public class testController {

    private static final Logger logger = LoggerFactory.getLogger(MemberListController.class);

    @RequestMapping(value = "/testList.do")
    public String testList(@RequestParam Map<String, Object> params, ModelMap model,SessionVO sessionVO) {

        logger.debug("==================== testList.do ====================");

        return "test/testList";
    }

}
