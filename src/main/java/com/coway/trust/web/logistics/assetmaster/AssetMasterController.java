package com.coway.trust.web.logistics.assetmaster;

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

import com.coway.trust.biz.logistics.asset.AssetMngService;
import com.coway.trust.config.handler.SessionHandler;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/logistics/assetmng")
public class AssetMasterController {

	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
@Value("${app.name}")
	private String appName;

	@Resource(name = "AssetMngService")
	private AssetMngService ams;
	
	@Autowired
	private MessageSourceAccessor messageAccessor;
	
	@Autowired
	private SessionHandler sessionHandler;
	

	@RequestMapping(value = "/AssetMaster.do")
	public String listdevice(Model model, HttpServletRequest request, HttpServletResponse response) throws Exception {
		return "logistics/AssetMng/assetList";
	}

	@RequestMapping(value = "/assetList.do", method = RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> selectCourierList(@RequestBody Map<String, Object> params,
			ModelMap model) throws Exception {
		
		/*String assetid     = request.getParameter("assetid");
		String branchId     = request.getParameter("branchid");
		String locdesc      = request.getParameter("locdesc");
		String loccd        = request.getParameter("loccd");
		System.out.println("assetid ::::::         "  +assetid);
		Map<String, Object> smap = new HashMap();
		smap.put("assetid", assetid);
		smap.put("status" , statusCd);
		smap.put("locdesc"  , locdesc);
		smap.put("loccd"  , loccd);*/

		List<EgovMap> list = ams.selectAssetList(params);
		
		Map<String, Object> map = new HashMap();
		map.put("data", list);

		return ResponseEntity.ok(map);
	}	
}
