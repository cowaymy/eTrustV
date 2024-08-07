/**
 * @author Adrian C.

 **/
package com.coway.trust.web.logistics.hsfilterforecast;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

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
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.logistics.hsfilterforecast.HSFilterForecastService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.handler.SessionHandler;
import com.coway.trust.util.CommonUtils;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import opennlp.tools.coref.mention.Parse;

@Controller
@RequestMapping(value = "/logistics/hsfilterforecast")
public class HSFilterForecastController {

	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	@Value("${app.name}")
	private String appName;

	@Resource(name = "HSFilterForecastService")
	private HSFilterForecastService hsFilterForecastService;

	@Autowired
	private MessageSourceAccessor messageAccessor;

	@Autowired
	private SessionHandler sessionHandler;

	@RequestMapping(value = "/hsFilterForecastList.do")
	public String HSFilterForecast(Model model, HttpServletRequest request, HttpServletResponse response)
    throws Exception
	{
		return "logistics/HSFilterForecast/hsFilterForecastList";
	}

	@RequestMapping(value = "/selectHSFilterForecastList.do", method = RequestMethod.POST)
	public ResponseEntity<Map> selectHSFilterForecastList(@RequestBody Map<String, Object> params, Model model)
	throws Exception
	{
		/*if("".equals(params.get("fcastDate")) || null == params.get("fcastDate"))
		{
			DateTimeFormatter dtf = DateTimeFormatter.ofPattern("dd/MM/yyyy");
			LocalDate localDate = LocalDate.now();

			params.replace("fcastDate", dtf.format(localDate).toString());
		}

		if(!"".equals(params.get("mthCount")) || null != params.get("mthCount"))
		{
			Integer i = 0;
			int var = Integer.parseInt(params.get("mthCount").toString());

			for (i = 1; i <= var; ++i)
			{
				params.replace("mth" + i.toString(), i);
			}
		}*/

		List<EgovMap> list = hsFilterForecastService.selectHSFilterForecastList(params);

		for (int i = 0; i < list.size(); i++)
		{
			logger.debug("list ??  : {}", list.get(i));
		}

		Map<String, Object> map = new HashMap();
		map.put("data", list);

		return ResponseEntity.ok(map);
	}

	@RequestMapping(value = "/selectForecastDetailsList.do", method = RequestMethod.POST)
	public ResponseEntity<Map> selectForecastDetailsList(@RequestBody Map<String, Object> params, Model model)
	throws Exception
	{

		if("".equals(params.get("hiddenfcastDate")) || null == params.get("hiddenfcastDate"))
		{
			DateTimeFormatter dtf = DateTimeFormatter.ofPattern("dd/MM/yyyy");
			LocalDate localDate = LocalDate.now();

			params.replace("hiddenfcastDate", dtf.format(localDate).toString());
		}

		if (!"".equals(params.get("loctype")) || null != params.get("loctype"))
		{
			logger.debug("loctype : {}", params.get("loctype"));

			List<Object> tmp = (List<Object>) params.get("loctype");
			params.put("locList", tmp);
		}

		if (!"".equals(params.get("brnch")) || null != params.get("brnch"))
		{
			logger.debug("brnch : {}", params.get("brnch"));

			List<Object> tmp = (List<Object>) params.get("brnch");
			params.put("brnchList", tmp);
		}

		List<EgovMap> list = hsFilterForecastService.selectForecastDetailsList(params);

		for (int i = 0; i < list.size(); i++)
		{
			logger.debug("list ??  : {}", list.get(i));
		}

		Map<String, Object> map = new HashMap();
		map.put("data", list);

		return ResponseEntity.ok(map);
	}
}
