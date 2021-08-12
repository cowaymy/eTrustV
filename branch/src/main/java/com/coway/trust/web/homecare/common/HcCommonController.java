/**
 *
 */
package com.coway.trust.web.homecare.common;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.biz.homecare.common.HcCommonService;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * homeCare Popup Mgt
 * @author KR-Jin
 *
 */
@Controller
@RequestMapping(value = "/homecare")
public class HcCommonController {

	//private static Logger logger = LoggerFactory.getLogger(HomecareCommonController.class);

	//@Autowired
	//private MessageSourceAccessor messageAccessor;

	@Resource(name = "hcCommonService")
	private HcCommonService hcCommonService;


	// 1.homecare AS order search popup
	@RequestMapping(value = "/sales/ccp/searchOrderNoPop.do")
	public String	searchOrderNoPop (@RequestParam Map<String, Object> params) throws Exception{
		return "homecare/common/hcCcpAgreementSearchOrderNoPop";
	}

	// 1.1 homecare AS order search popup Search
	@RequestMapping(value = "/sales/ccp/selectsearchOrderNo.do")
	public ResponseEntity<List<EgovMap>> selectsearchOrderNo (@RequestParam Map<String, Object> params , HttpServletRequest request) throws Exception{
		List<EgovMap> ordList = null;
		String appType [] = request.getParameterValues("searchOrdAppType");

		params.put("appType", appType);
		ordList = hcCommonService.selectSearchOrderNo(params);
		return ResponseEntity.ok(ordList);

	}






}
