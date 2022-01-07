package com.coway.trust.web.logistics.hsfilter;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

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

import com.coway.trust.biz.logistics.hsfilter.HsFilterDeliveryService;
import com.coway.trust.biz.logistics.hsfilter.HsFilterForecastService;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.handler.SessionHandler;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/logistics/HsFilterNewForecast")

public class HsFilterForecastController {

  private static final Logger LOGGER = LoggerFactory.getLogger(HsFilterForecastController.class);

  @Autowired
  private MessageSourceAccessor messageAccessor;

  @Autowired
  private SessionHandler sessionHandler;

  @Resource(name = "HsFilterForecastService")
  private HsFilterForecastService hsFilterFocastService;


  @Resource(name = "HsFilterDeliveryService")
  private HsFilterDeliveryService hsFilterDeliveryService;


  @RequestMapping(value = "/hsFilterFocastList.do")
  public String hsFilterDeliveryList(@RequestParam Map<String, Object> params, ModelMap model) throws Exception {

    SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
    params.put("userId", sessionVO.getUserId());
    // TODO 유저 권한에 따라 리스트 검색 조건 변경 (추후) change



    return "logistics/hsfilter/hsFilterForecastList";
  }



	@RequestMapping(value = "/selectHSFilterForecastBranchList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectHSFilterForecastBranchList(@RequestParam Map<String, Object> params) {

		List<EgovMap> list = hsFilterDeliveryService.selectHSFilterDeliveryBranchList(params);
		return ResponseEntity.ok(list);
	}


	@RequestMapping(value = "/selectHSFilterForecastList.do")
	public ResponseEntity<List<EgovMap>> selectHSFilterDeliveryList(@RequestParam Map<String, Object> params) throws Exception {


		List<EgovMap> list = hsFilterFocastService.selectHSFilterForecastList(params);


		return ResponseEntity.ok(list);
	}
}
