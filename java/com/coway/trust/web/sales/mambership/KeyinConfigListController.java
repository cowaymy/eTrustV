
package com.coway.trust.web.sales.mambership;

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
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import com.coway.trust.AppConstants;
import com.coway.trust.biz.sales.mambership.KeyinConfigService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.handler.SessionHandler;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/sales/membership")
public class KeyinConfigListController {

	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	@Value("${app.name}")
	private String appName;

	@Resource(name = "keyinConfigService")
	private KeyinConfigService KeyinConfig;


	// DataBase message accessor....
	@Autowired
	private MessageSourceAccessor messageAccessor;

	@Autowired
	private SessionHandler sessionHandler;

	@RequestMapping(value = "/keyinConfig.do")
	public String listdevice(Model model, HttpServletRequest request, HttpServletResponse response) throws Exception {

		return "sales/membership/keyinConfigList";
	}

	@RequestMapping(value = "/keyinConfigList.do", method = RequestMethod.GET)
	public ResponseEntity<Map> selectkeyinConfigList(ModelMap model, HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		String[] cate = request.getParameterValues("cmbCategory");
		String[] status = request.getParameterValues("cmbStatus");
		String stkNm = request.getParameter("stkNm");
		String stkCd = request.getParameter("stkCd");


		Map<String, Object> smap = new HashMap();
		smap.put("cateList", cate);
		smap.put("statList", status);
		smap.put("stkNm", stkNm);
		smap.put("stkCd", stkCd);

		List<EgovMap> list = KeyinConfig.selectkeyinConfigList(smap);

		Map<String, Object> map = new HashMap();
		map.put("data", list);

		return ResponseEntity.ok(map);
	}

	@RequestMapping(value = "/updateAllowSalesStatus.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> updateAllowSalesStatus(@RequestBody Map<String, Object> params, SessionVO sessionVO) throws Exception {
		// 주문 수정

		KeyinConfig.updateAllowSalesStatus(params, sessionVO);

		String msg = "Status successfully updated.<br />";

		// 결과 만들기
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(msg);

		return ResponseEntity.ok(message);
	}

}
