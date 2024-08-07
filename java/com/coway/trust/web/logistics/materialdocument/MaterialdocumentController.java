package com.coway.trust.web.logistics.materialdocument;

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
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.biz.logistics.materialdocument.MaterialDocumentService;
import com.coway.trust.config.handler.SessionHandler;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/logistics/materialDoc")
public class MaterialdocumentController {

	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	@Value("${app.name}")
	private String appName;

	@Resource(name = "MaterialDocumentService")
	private MaterialDocumentService MaterialDocumentService;

	@Autowired
	private MessageSourceAccessor messageAccessor;

	@Autowired
	private SessionHandler sessionHandler;

	@RequestMapping(value = "/MaterialdocIns.do")
	public String MaterialdocIns(Model model, HttpServletRequest request, HttpServletResponse response)
			throws Exception {

		return "logistics/MaterialDocument/materialDocumentList";
	}

	@RequestMapping(value = "/selectLocation.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectLocation(@RequestParam Map<String, Object> params) {

		logger.debug("selectBrandListCode : {}", params.get("groupCode"));

		List<EgovMap> LocationList = MaterialDocumentService.selectLocation(params);
		// for (int i = 0; i < LocationList.size(); i++) {
		// logger.debug("%%%%%%%%BrandList%%%%%%%: {}", LocationList.get(i));
		// }

		return ResponseEntity.ok(LocationList);
	}

	@RequestMapping(value = "/MaterialDocSearchList.do", method = RequestMethod.GET)
	public ResponseEntity<Map> MaterialDocSearchList(@RequestParam Map<String, Object> params,
			HttpServletRequest request, ModelMap model) throws Exception {

		String[] trantype = request.getParameterValues("searchTrcType");
		String[] movetype = request.getParameterValues("searchMoveType");
		String searchMaterialDoc = request.getParameter("searchMaterialDoc");
		String isHomeCare = request.getParameter("sIsHomeCare"); //Homecare - logistics page
		String posdatefr = request.getParameter("PostingDt1");
		String posdateto = request.getParameter("PostingDt2");
		String crtdatefr = request.getParameter("CreateDt1");
		String crtdateto = request.getParameter("CreateDt2");
		String[] frloctype = request.getParameterValues("sfrLoctype");
		String[] toloctype = request.getParameterValues("stoLoctype");
		String frlocgrade = request.getParameter("sfrLocgrade");
		String tolocgrade = request.getParameter("stoLocgrade");
		String[] frloc = request.getParameterValues("sfrLoc");
		String[] toloc = request.getParameterValues("stoLoc");
		String materialcode = request.getParameter("searchMaterialCode");
		String[] smattype = request.getParameterValues("smattype");
		String[] smatcate = request.getParameterValues("smatcate");
		String sdocno = request.getParameter("sdocno");
		String sreqstno = request.getParameter("sreqstno");
		String sdelvno = request.getParameter("sdelvno");
		String sam = request.getParameter("sam");
		String sordno = request.getParameter("sordno");
		String mainloc = request.getParameter("mainloc").trim();
		String ordno = request.getParameter("ordno");
		String serialNo = request.getParameter("serialNo"); // 20191122 KR-OHK Serial No Add

		logger.debug("mainloc trim@@@@@@@ : {}", mainloc);

		Map<String, Object> pmap = new HashMap();
		pmap.put("isHomeCare", isHomeCare); //Homecare - logistics page
		pmap.put("trantype", trantype);
		pmap.put("movetype", movetype);
		pmap.put("matdoc", searchMaterialDoc);
		pmap.put("posdatefr", posdatefr);
		pmap.put("posdateto", posdateto);
		pmap.put("crtdatefr", crtdatefr);
		pmap.put("crtdateto", crtdateto);
		pmap.put("frloctype", frloctype);
		pmap.put("toloctype", toloctype);
		pmap.put("frlocgrade", frlocgrade);
		pmap.put("tolocgrade", tolocgrade);
		pmap.put("frloc", frloc);
		pmap.put("toloc", toloc);
		pmap.put("materialcode", materialcode);
		pmap.put("smattype", smattype);
		pmap.put("smatcate", smatcate);
		pmap.put("sdocno", sdocno);
		pmap.put("sreqstno", sreqstno);
		pmap.put("sdelvno", sdelvno);
		pmap.put("sam", sam);
		pmap.put("sordno", sordno);
		pmap.put("mainloc", mainloc);
		pmap.put("ordno", ordno);
		pmap.put("serialNo", serialNo);

		List<EgovMap> list = MaterialDocumentService.MaterialDocSearchList(pmap);

		Map<String, Object> map = new HashMap();
		map.put("data", list);

		return ResponseEntity.ok(map);
	}

	@RequestMapping(value = "/selectTrntype.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectTrntype(@RequestParam Map<String, Object> params,
			HttpServletRequest request, ModelMap model) throws Exception {
		List<EgovMap> result = null;
		String codematerid = request.getParameter("masterid");
		String[] searchTrcType = request.getParameterValues("searchTrcType");
		Map<String, Object> map = new HashMap();
		map.put("strctype", searchTrcType);
		result = MaterialDocumentService.MaterialDocMovementType(map);

		return ResponseEntity.ok(result);
	}

	//  20191122 KR-OHK Serial List Add
	@RequestMapping(value = "/selectMaterialDocSerialList.do", method = RequestMethod.GET)
	public ResponseEntity<Map> selectMaterialDocSerialList(@RequestParam Map<String, Object> params,
			HttpServletRequest request, ModelMap model) throws Exception {

		List<EgovMap> list = MaterialDocumentService.selectMaterialDocSerialList(params);

		Map<String, Object> map = new HashMap();
		map.put("data", list);

		return ResponseEntity.ok(map);
	}

	 // Homecare - Material Documents List
	@RequestMapping(value = "/htMaterialdocIns.do")
	public String htMaterialdocIns(Model model, HttpServletRequest request, HttpServletResponse response)
			throws Exception {

		return "logistics/MaterialDocument/materialDocumentList";
	}


	@RequestMapping(value = "/MaterialdocInsUpTo.do")
	public String MaterialdocInsUpTo(Model model, HttpServletRequest request, HttpServletResponse response)
			throws Exception {

		return "logistics/MaterialDocument/materialDocumentList_upto";
	}

	@RequestMapping(value = "/htMaterialdocInsUpTo.do")
	public String htMaterialdocInsUpTo(Model model, HttpServletRequest request, HttpServletResponse response)
			throws Exception {

		return "logistics/MaterialDocument/materialDocumentList_upto";
	}

	@RequestMapping(value = "/MaterialDocSearchListUpTo.do", method = RequestMethod.GET)
	public ResponseEntity<Map> MaterialDocSearchListUpTo(@RequestParam Map<String, Object> params,
			HttpServletRequest request, ModelMap model) throws Exception {

		String[] trantype = request.getParameterValues("searchTrcType");
		String[] movetype = request.getParameterValues("searchMoveType");
		String searchMaterialDoc = request.getParameter("searchMaterialDoc");
		String isHomeCare = request.getParameter("sIsHomeCare"); //Homecare - logistics page
		String posdatefr = request.getParameter("PostingDt1");
		String posdateto = request.getParameter("PostingDt2");
		String crtdatefr = request.getParameter("CreateDt1");
		String crtdateto = request.getParameter("CreateDt2");
		String[] frloctype = request.getParameterValues("sfrLoctype");
		String[] toloctype = request.getParameterValues("stoLoctype");
		String frlocgrade = request.getParameter("sfrLocgrade");
		String tolocgrade = request.getParameter("stoLocgrade");
		String[] frloc = request.getParameterValues("sfrLoc");
		String[] toloc = request.getParameterValues("stoLoc");
		String materialcode = request.getParameter("searchMaterialCode");
		String[] smattype = request.getParameterValues("smattype");
		String[] smatcate = request.getParameterValues("smatcate");
		String sdocno = request.getParameter("sdocno");
		String sreqstno = request.getParameter("sreqstno");
		String sdelvno = request.getParameter("sdelvno");
		String sam = request.getParameter("sam");
		String sordno = request.getParameter("sordno");
		String mainloc = request.getParameter("mainloc").trim();
		String ordno = request.getParameter("ordno");
		String serialNo = request.getParameter("serialNo"); // 20191122 KR-OHK Serial No Add

		logger.debug("mainloc trim@@@@@@@ : {}", mainloc);

		Map<String, Object> pmap = new HashMap();
		pmap.put("isHomeCare", isHomeCare); //Homecare - logistics page
		pmap.put("trantype", trantype);
		pmap.put("movetype", movetype);
		pmap.put("matdoc", searchMaterialDoc);
		pmap.put("posdatefr", posdatefr);
		pmap.put("posdateto", posdateto);
		pmap.put("crtdatefr", crtdatefr);
		pmap.put("crtdateto", crtdateto);
		pmap.put("frloctype", frloctype);
		pmap.put("toloctype", toloctype);
		pmap.put("frlocgrade", frlocgrade);
		pmap.put("tolocgrade", tolocgrade);
		pmap.put("frloc", frloc);
		pmap.put("toloc", toloc);
		pmap.put("materialcode", materialcode);
		pmap.put("smattype", smattype);
		pmap.put("smatcate", smatcate);
		pmap.put("sdocno", sdocno);
		pmap.put("sreqstno", sreqstno);
		pmap.put("sdelvno", sdelvno);
		pmap.put("sam", sam);
		pmap.put("sordno", sordno);
		pmap.put("mainloc", mainloc);
		pmap.put("ordno", ordno);
		pmap.put("serialNo", serialNo);

		List<EgovMap> list = MaterialDocumentService.MaterialDocSearchListUpTo(pmap);

		Map<String, Object> map = new HashMap();
		map.put("data", list);

		return ResponseEntity.ok(map);
	}

}
