package com.coway.trust.web.logistics.design;

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
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.logistics.design.ArtworkRequestService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.handler.SessionHandler;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/logistics/design")
public class ArtworkRequestController {


	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	@Value("${app.name}")
	private String appName;

	@Resource(name = "artwork")
	private ArtworkRequestService artservice;

	@Autowired
	private MessageSourceAccessor messageAccessor;

	@Autowired
	private SessionHandler sessionHandler;

	@RequestMapping(value = "/ArtworkRequestList.do")
	public String ArtworkRequestList(Model model, HttpServletRequest request, HttpServletResponse response) throws Exception {

		return "logistics/Design/ArtworkRequestList";
	}

	@RequestMapping(value = "/ArtworkDownloadList.do")
	public String ArtworkDownloadList(Model model, HttpServletRequest request, HttpServletResponse response) throws Exception {

		return "logistics/Design/ArtworkDownloadList";
	}

	@RequestMapping(value = "/ArtworkPrintDownloadList.do")
    public String ArtworkPrintDownloadList(Model model, HttpServletRequest request, HttpServletResponse response) throws Exception {

        return "logistics/Design/ArtworkPrintDownloadList";
    }

	@RequestMapping(value = "/ArtworkNewLogo.do")
    public String ArtworkNewLogo(Model model, HttpServletRequest request, HttpServletResponse response) throws Exception {

        return "logistics/Design/ArtworkNewLogo";
    }

	@RequestMapping(value = "/MarketingMaterials.do")
    public String MarketingMaterials(Model model, HttpServletRequest request, HttpServletResponse response) throws Exception {

        return "logistics/Design/MarketingMaterials";
    }

	@RequestMapping(value = "/selectArtworkCategory.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectArtworkCateList(@RequestParam Map<String, Object> params,
			ModelMap model) {

		logger.debug(" ::: {}" , params);

		List<EgovMap> codeList = artservice.selectArtworkCategoryList(params);

		return ResponseEntity.ok(codeList);
	}

	@RequestMapping(value = "/selectArtworkList.do", method = RequestMethod.POST)
	public ResponseEntity<List<EgovMap>> selectArtworkList(@RequestBody Map<String, Object> params, Model model)
			throws Exception {
		logger.debug(" ::: {}" , params);

		List<EgovMap> list = artservice.selectArtworkList(params);

		return ResponseEntity.ok(list);
	}

	@RequestMapping(value = "/MarketingMaterial.do")
	public String ArtworkDownloadNav(Model model, HttpServletRequest request, HttpServletResponse response) throws Exception {

		return "logistics/Design/MarketingMaterialList";
	}
}
