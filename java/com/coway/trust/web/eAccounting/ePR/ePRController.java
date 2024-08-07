package com.coway.trust.web.eAccounting.ePR;

import java.io.File;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.function.Predicate;
import java.util.stream.Collectors;

import org.apache.poi.openxml4j.exceptions.InvalidFormatException;
import org.apache.poi.ss.usermodel.Cell;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.coway.trust.biz.common.AdaptorService;
import com.coway.trust.biz.common.FileService;
import com.coway.trust.biz.common.FileVO;
import com.coway.trust.biz.common.type.FileType;
import com.coway.trust.biz.eAccounting.ePR.ePRService;
import com.coway.trust.cmmn.file.EgovFileUploadUtil;
import com.coway.trust.cmmn.model.EmailVO;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.excel.ExcelReadComponent;
import com.google.common.base.Objects;
import com.google.gson.Gson;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/eAccounting/ePR")
public class ePRController {
	private static final Logger LOGGER = LoggerFactory.getLogger(ePRController.class);

	@Value("${web.resource.upload.file}")
	private String uploadDir;

	 @Autowired
	 private ePRService ePRService;

	 @Autowired
	 private ExcelReadComponent excelReadComponent;

	 @Autowired
	 private FileService fileService;

	 @Autowired
	 private AdaptorService adaptorService;

	@RequestMapping(value="/ePR.do")
	public String ePR(ModelMap model, SessionVO sessionVO) throws Exception {
		model.put("curr", sessionVO.getUserId());
		model.put("currName", sessionVO.getUserName());
		List<EgovMap> requests = ePRService.selectRequests(model);
		model.put("requests", new Gson().toJson(requests));
		return "eAccounting/ePR/ePR";
	}

	@RequestMapping(value="/getEPR.do")
	public ResponseEntity<List<EgovMap>> getEPR(SessionVO sessionVO, @RequestParam Map<String, Object> p) {
		p.put("curr", sessionVO.getUserId());
		return ResponseEntity.ok(ePRService.selectRequests(p));
	}

	@RequestMapping(value="/cancelEPR.do")
	public String cancelEPR(ModelMap model, @RequestParam Map<String, Object> p) throws Exception {
		EgovMap request = ePRService.selectRequest(p);
		model.put("request", new Gson().toJson(request));
		return "eAccounting/ePR/ePRCancel";
	}

	@RequestMapping(value="/cfmCancelEPR.do", method=RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> cfmCancelEPR(@RequestBody Map<String, Object> p, SessionVO sessionVO) {
		Map<String, Object> res = new HashMap();
		p.put("crtUsr", sessionVO.getUserId());
		res.put("success", ePRService.cancelEPR(p));
		return ResponseEntity.ok(res);
	}

	@RequestMapping(value="/ePRRequests.do")
	public ResponseEntity<List<EgovMap>> ePRRequests(ModelMap model) throws Exception {
		List<EgovMap> requests = ePRService.selectRequests(model);
		return ResponseEntity.ok(requests);
	}

	@RequestMapping("/spcMembers.do")
	public ResponseEntity<List<EgovMap>> spcMembers() {
		return ResponseEntity.ok(ePRService.getSPCMembers());
	}

	@RequestMapping("/viewEPRForm.do")
	public String viewEPRForm(@RequestParam Map<String, Object> p, ModelMap model, SessionVO sessionVO) {
		EgovMap request = ePRService.selectRequest(p);
		model.put("request", new Gson().toJson(request));
		EgovMap finalApprv = ePRService.getFinalApprv();
		model.put("f", finalApprv);
		if (request.get("stus") != null && !((BigDecimal) request.get("stus")).equals(new BigDecimal(120))) {
			EgovMap currentApprover = ePRService.getCurrApprv(p);
			if (
					currentApprover != null &&
					currentApprover.get("memId").equals(sessionVO.getMemId()) &&
					(
							((BigDecimal) request.get("stus")).equals(new BigDecimal(121)) ||
							((BigDecimal) request.get("stus")).equals(new BigDecimal(44))
					)
			) {
				model.put("openDecision", true);
			}
			List<EgovMap> spcMembers = ePRService.getSPCMembers();
			if (((List<EgovMap>) request.get("approvals")).stream().filter((a) -> {
				return a.get("stus").equals("Pending");
			}).count() == 1) {
				EgovMap lastSPC = ((List<EgovMap>) request.get("approvals")).stream().filter((a) -> {
					return a.get("seq").equals(new BigDecimal((((List<EgovMap>) request.get("approvals")).size() - 1)));
				}).findFirst().get();
				model.put("spcMem", lastSPC.get("memCode"));
				model.put("spcMembers", spcMembers);
			}
			if (request.get("stus").equals(new BigDecimal(5)) && spcMembers.stream().filter(spcMem -> spcMem.get("memId").equals(new BigDecimal(sessionVO.getMemId()))).count() > 0) {
				model.put("editable", true);
				model.put("spcMembers", spcMembers);
			}
			return "eAccounting/ePR/ePRView";
		}
		return "eAccounting/ePR/ePRFormPop";
	}

	@RequestMapping(value="/newEPRPop.do")
	public String newEPR(ModelMap model, SessionVO sessionVO) {
		Map<String, Object> request = new HashMap<String, Object>();
		request.put("memCode", sessionVO.getUserMemCode());
		EgovMap costCenter = ePRService.selectUserCostCenter(request);
		if (costCenter != null) {
			request.put("costCenter", costCenter.get("costCenter"));
			request.put("costCenterText", costCenter.get("costCenterText"));
		}
		model.put("request", new Gson().toJson(request));
		EgovMap finalApprv = ePRService.getFinalApprv();
		model.put("f", finalApprv);
		return "eAccounting/ePR/ePRFormPop";
	}

	@RequestMapping(value="/deleteEPR.do", method=RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> deleteEPR(@RequestParam Map<String, Object> p) {
		ePRService.deleteRequest(p);
		ePRService.deleteRequestItems(p);
		Map<String, Object> result = new HashMap<String, Object>();
		result.put("success", 1);
		return ResponseEntity.ok(result);
	}

	@Transactional
	@RequestMapping(value="/editEPR.do", method=RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> editEPR(MultipartHttpServletRequest request, SessionVO sessionVO) throws InvalidFormatException, IOException {
		Map<String, Object> response = new HashMap<String, Object>();
		Map<String, Object> params = new HashMap<String, Object>();
		List<Integer> dbRes = new ArrayList();

		//Get other form data
		Map<String, Object> p = new Gson().fromJson(request.getParameter("data"), HashMap.class);

		params.put("remark", p.get("remark"));
		params.put("type", p.get("type"));
		params.put("crtUsr", sessionVO.getUserId());
		params.put("id", p.get("id"));
		if (p.get("type").equals("0")) {
			params.put("newAssign", p.get("assignMemId"));
			params.put("rciv", null);
		} else {
			params.put("newAssign", null);
			//Extract Delivery Excel data
			List<Map<String, Cell>> result = excelReadComponent.readExcelToList(request.getFile("rciv"), 0, r -> {
				Map<String, Cell> result2 = new HashMap<String, Cell>();
				result2.put("item", r.getCell(0));
				result2.put("quantity", r.getCell(1));
				result2.put("uom", r.getCell(2));
				result2.put("usage", r.getCell(3));
				result2.put("branch", r.getCell(4));
				result2.put("type", r.getCell(5));
				result2.put("branchCode", r.getCell(6));
				result2.put("region", r.getCell(7));
				result2.put("pic", r.getCell(8));
				result2.put("contact", r.getCell(9));
				result2.put("address", r.getCell(10));
				return result2;
			});

			//Check Delivery Excel format
			HashMap<String, String> x = new HashMap();
			x.put("item", "Item");
			x.put("quantity", "Quantity");
			x.put("uom", "UOM");
			x.put("usage", "Usage Month");
			x.put("branch", "Branch Name");
			x.put("type", "Branch Type");
			x.put("branchCode", "Branch Code");
			x.put("region", "Region");
			x.put("pic", "PIC");
			x.put("contact", "Contact No.");
			x.put("address", "Address");
			if (Objects.equal(result.get(0).toString(), x.toString())) {

				//Extract data type from Cell
				List<Map<String, Object>> excelData = result.subList(1, result.size()).stream().filter(r -> r.get("item") != null).map(r -> {
					Map<String, Object> rRes = new HashMap<String, Object>();
					rRes.put("item", r.get("item") == null ? null : r.get("item").getStringCellValue());
					rRes.put("quantity", r.get("quantity") == null ? null : r.get("quantity").getStringCellValue());
					rRes.put("uom", r.get("uom") == null ? null : r.get("uom").getStringCellValue());
					rRes.put("usage", r.get("usage") == null ? null : r.get("usage").getStringCellValue());
					rRes.put("branch", r.get("branch") == null ? null : r.get("branch").getStringCellValue());
					rRes.put("type", r.get("type") == null ? null : r.get("type").getStringCellValue());
					rRes.put("branchCode", r.get("branchCode") == null ? null : r.get("branchCode").getStringCellValue());
					rRes.put("region", r.get("region") == null ? null : r.get("region").getStringCellValue());
					rRes.put("pic", r.get("pic") == null ? null : r.get("pic").getStringCellValue());
					rRes.put("contact", r.get("contact") == null ? null : r.get("contact").getStringCellValue());
					rRes.put("address", r.get("address") == null ? null : r.get("address").getStringCellValue());
					return rRes;
				}).collect(Collectors.toList());

				//Upload files and get key
				int fileGroupKey = fileService.insertFiles(FileVO.createList(EgovFileUploadUtil.getUploadExcelFilesRVO(request.getFile("rciv"), uploadDir, File.separator + "procurement" + File.separator + "ePR")), FileType.WEB_DIRECT_RESOURCE, sessionVO.getUserId());
				params.put("rciv", fileGroupKey);

				if (excelData.size() > 0) {

					//Delete Previous Delivery data
					dbRes.add(ePRService.deleteDeliverDet(p));

					//Insert Delivery data
					for(Map<String, Object> d : excelData) {
						d.put("id", p.get("id"));
						int res2 = ePRService.insertDeliverDet(d);
						dbRes.add(res2);
					}

				} else {
					dbRes.add(1);
//					response.put("success", 0);
//					response.put("err", "Excel has no data");
//					return ResponseEntity.ok(response);
				}
			} else {
				response.put("success", 0);
				response.put("err", "Excel Format incorrect");
				return ResponseEntity.ok(response);
			}
		}

		dbRes.add(ePRService.insertEditHistory(params));

		int ret = dbRes.stream().allMatch((i) -> i > 0) ? 1 : 0;
		response.put("success", ret);
		return ResponseEntity.ok(response);
	}

	@Transactional
	@RequestMapping(value="/submitEPR.do", method=RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> submitEPR(MultipartHttpServletRequest request, SessionVO sessionVO) throws InvalidFormatException, IOException {
		Map<String, Object> response = new HashMap<String, Object>();
		EmailVO email = null;

		//Extract Delivery Excel data
		List<Map<String, Cell>> result = excelReadComponent.readExcelToList(request.getFile("rciv"), 0, r -> {
			Map<String, Cell> result2 = new HashMap<String, Cell>();
			result2.put("item", r.getCell(0));
			result2.put("quantity", r.getCell(1));
			result2.put("uom", r.getCell(2));
			result2.put("usage", r.getCell(3));
			result2.put("branch", r.getCell(4));
			result2.put("type", r.getCell(5));
			result2.put("branchCode", r.getCell(6));
			result2.put("region", r.getCell(7));
			result2.put("pic", r.getCell(8));
			result2.put("contact", r.getCell(9));
			result2.put("address", r.getCell(10));
			return result2;
		});

		//Check Delivery Excel format
		HashMap<String, String> x = new HashMap();
		x.put("item", "Item");
		x.put("quantity", "Quantity");
		x.put("uom", "UOM");
		x.put("usage", "Usage Month");
		x.put("branch", "Branch Name");
		x.put("type", "Branch Type");
		x.put("branchCode", "Branch Code");
		x.put("region", "Region");
		x.put("pic", "PIC");
		x.put("contact", "Contact No.");
		x.put("address", "Address");
		if (Objects.equal(result.get(0).toString(), x.toString())) {

			//Extract data type from Cell
			List<Map<String, Object>> excelData = result.subList(1, result.size()).stream().filter(r -> r.get("item") != null).map(r -> {
				Map<String, Object> rRes = new HashMap<String, Object>();
				rRes.put("item", r.get("item") == null ? null : r.get("item").getStringCellValue());
				try {
					rRes.put("quantity", r.get("quantity") == null ? null : r.get("quantity").getStringCellValue());
				} catch (IllegalStateException e) {
					rRes.put("quantity", r.get("quantity") == null ? null : r.get("quantity").getNumericCellValue());
				}
				rRes.put("uom", r.get("uom") == null ? null : r.get("uom").getStringCellValue());
				rRes.put("usage", r.get("usage") == null ? null : r.get("usage").getStringCellValue());
				rRes.put("branch", r.get("branch") == null ? null : r.get("branch").getStringCellValue());
				rRes.put("type", r.get("type") == null ? null : r.get("type").getStringCellValue());
				rRes.put("branchCode", r.get("branchCode") == null ? null : r.get("branchCode").getStringCellValue());
				rRes.put("region", r.get("region") == null ? null : r.get("region").getStringCellValue());
				rRes.put("pic", r.get("pic") == null ? null : r.get("pic").getStringCellValue());
				rRes.put("contact", r.get("contact") == null ? null : r.get("contact").getStringCellValue());
				rRes.put("address", r.get("address") == null ? null : r.get("address").getStringCellValue());
				return rRes;
			}).collect(Collectors.toList());

			List<Integer> dbRes = new ArrayList();

			//Get other form data
			Map<String, Object> p = new Gson().fromJson(request.getParameter("data"), HashMap.class);

			ArrayList<Map<String, Object>> members = (ArrayList<Map<String, Object>>) p.get("members");

			Map<String, Object> tentativeSPC = members.get(members.size() - 2);

			boolean includeSPC = ePRService.getSPCMembers().stream().anyMatch((m) -> {
				return m.get("memCode").equals(tentativeSPC.get("memCode"));
			});

			if (includeSPC) {

				//Upload files and get key
				int fileGroupKey = fileService.insertFiles(FileVO.createList(EgovFileUploadUtil.getUploadExcelFilesRVO(request.getFile("rciv"), uploadDir, File.separator + "procurement" + File.separator + "ePR")), FileType.WEB_DIRECT_RESOURCE, sessionVO.getUserId());
				p.put("rciv", fileGroupKey);

				if (request.getFile("add") != null) {
					int fileGroupKeyAdd = fileService.insertFiles(FileVO.createList(EgovFileUploadUtil.getUploadExcelFilesRVO(request.getFile("add"), uploadDir, File.separator + "procurement" + File.separator + "ePR")), FileType.WEB_DIRECT_RESOURCE, sessionVO.getUserId());
					p.put("add", fileGroupKeyAdd);
				}

				//Insert or update request based on the presence of "requestId"
				int res = ePRService.insertRequestDraft(p);
				dbRes.add(res);

				//Insert Delivery data
				for(Map<String, Object> d : excelData) {
					d.put("id", p.get("id"));
					int res2 = ePRService.insertDeliverDet(d);
					dbRes.add(res2);
				}

				//Delete Request items and re-insert
				if (p.get("requestId") != null) {
					ePRService.deleteRequestItems(p);
				}
				ArrayList<Map<String, Object>> details = (ArrayList<Map<String, Object>>) p.get("items");
				for(Map<String, Object> d : details) {
					d.put("id", p.get("id"));
					int res2 = ePRService.insertRequestItems(d);
					dbRes.add(res2);
				}

				//To-do add approval line
				for(int i = 0; i < members.size(); i++) {
					Map<String, Object> d = members.get(i);
					if (i == 0) {
						String addContent = "is in need of your approval.<br/><span style=\"color: red;\">Title: \"" + p.get("ePRTitle") + "\"</span>";
						email = prepareEmail(p.get("id").toString(), addContent);
						email.setTo(ePRService.getMemberEmail(d));
					}
					d.put("id", p.get("id"));
					d.put("seq", i+1);
					int res2 = ePRService.insertApprovalLine(d);
					dbRes.add(res2);
				}

				//Update Request to submitted
				int res3 = ePRService.updateRequest(p);
				dbRes.add(res3);
			} else {
				response.put("success", 0);
				response.put("err", "Approval must contain SPC member as second last approver");
				return ResponseEntity.ok(response);
			}
			int ret = dbRes.stream().allMatch((i) -> i > 0) ? 1 : 0;
			if (ret == 1) {
				if (email != null) {
					adaptorService.sendEmail(email, false);
				}
				response.put("success", p.get("id"));
				return ResponseEntity.ok(response);
			} else {
				response.put("success", 0);
				return ResponseEntity.ok(response);
			}
		} else {
			response.put("success", 0);
			response.put("err", "Receiver info Format incorrect");
			return ResponseEntity.ok(response);
		}
	}

	private EmailVO prepareEmail(String ePRNo, String addContent) {
		for (int i = ePRNo.length(); i < 5; i++) {
			ePRNo = "0" + ePRNo;
		}
		EmailVO email = new EmailVO();
		email.setHtml(true);
		email.setSubject("ePR Approval");
		String content = "";
        content += "Dear Sir/Madam,<br/><br/>";
        content += "Kindly be noted that <span style=\"color: red;\">\"PR No.: PR" + ePRNo + "\"</span> " + addContent;
        content += "<br/><br/>May refer to : Etrust > Misc > Procurement";
        email.setText(content);
        return email;
	}

	@RequestMapping(value="/ePRApproval.do", method=RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> ePRApproval(@RequestBody Map<String, Object> p, SessionVO sessionVO) {
		p.put("memId", sessionVO.getMemId());
		int res = ePRService.ePRApproval(p);
		EgovMap curr = ePRService.getCurrApprv(p);
		EgovMap req = ePRService.selectRequest(p);
		if (res == 1 && (((BigDecimal) req.get("stus")).intValueExact() == 5 || ((BigDecimal) req.get("stus")).intValueExact() == 6)) {
			String content = "Submitted on date " + req.get("submitDt");
			if ((int) p.get("stus") == 5) {
				content += " has been approved.";
			} else if ((int) p.get("stus") == 6) {
				content += " has been rejected.";
			}
			content += "</br><span style=\"color: red;\">Title : \"" + req.get("title") + "\"</span>";
			EmailVO email = prepareEmail(p.get("requestId").toString(), content);
			email.setTo((String) req.get("email"));
			adaptorService.sendEmail(email, false);
		} else if (res == 1 && ((BigDecimal) req.get("stus")).intValueExact() != 6) {
			String content = "is in need of your approval.";
			content += "</br><span style=\"color: red;\">" + req.get("title") + "</span>";
			EmailVO email = prepareEmail(p.get("requestId").toString(), content);
			email.setTo((String) curr.get("email"));
			adaptorService.sendEmail(email, false);
		}
		Map<String, Object> result = new HashMap<String, Object>();
		result.put("success", res);
		return ResponseEntity.ok(result);
	}

	@RequestMapping(value="/draftEPR.do", method=RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> draftEPR(@RequestBody Map<String, Object> p) {
		List results = new ArrayList();
		int res = ePRService.insertRequestDraft(p);
		results.add(res);
		ArrayList<Map<String, Object>> details = (ArrayList<Map<String, Object>>) p.get("items");
		if (p.get("requestId") != null) {
			ePRService.deleteRequestItems(p);
		}
		for(Map<String, Object> d : details) {
			d.put("id", p.get("id"));
    		int res2 = ePRService.insertRequestItems(d);
    		results.add(res2);
		}
		Map<String, Object> result = new HashMap<String, Object>();
		result.put("success", 1);
		return ResponseEntity.ok(result);
	}
}