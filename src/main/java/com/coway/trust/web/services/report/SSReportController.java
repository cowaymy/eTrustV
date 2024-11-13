package com.coway.trust.web.services.report;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.cmmn.model.SessionVO;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/services/ss/report")
public class SSReportController {
  private static final Logger logger = LoggerFactory.getLogger(SSReportController.class);

  @RequestMapping(value = "/ssFilterForecastListingPop.do")
  public String filterForecastPop(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {
    return "services/ss/ssFilterForecastListingPop";
  }

}
