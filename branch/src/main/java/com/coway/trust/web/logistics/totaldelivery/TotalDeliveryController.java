/**
 * @author Adrian C.
 **/
package com.coway.trust.web.logistics.totaldelivery;

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
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.logistics.totaldelivery.TotalDeliveryService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.handler.SessionHandler;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/logistics/TotalDelivery")
public class TotalDeliveryController
{
	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	@Value("${app.name}")
	private String appName;

	@Resource(name = "TotalDeliveryService")
	private TotalDeliveryService delivery;

	@Autowired
	private MessageSourceAccessor messageAccessor;

	@Autowired
	private SessionHandler sessionHandler;

	@RequestMapping(value = "/totalDeliveryList.do")
	public String totalDeliveryList(Model model, HttpServletRequest request, HttpServletResponse response)
	throws Exception
	{
		return "logistics/TotalDelivery/totalDeliveryList";
	}

	@RequestMapping(value = "/SearchTotalDeliveryList.do", method = RequestMethod.POST)
	public ResponseEntity<Map> SearchTotalDeliveryList(@RequestBody Map<String, Object> params, Model model)
	throws Exception
	{
		List<EgovMap> list = delivery.selectTotalDeliveryList(params);

		Map<String, Object> map = new HashMap();
		map.put("data", list);

		return ResponseEntity.ok(map);
	}

}