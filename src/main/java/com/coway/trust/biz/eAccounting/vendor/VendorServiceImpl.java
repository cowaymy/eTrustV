package com.coway.trust.biz.eAccounting.vendor;

import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.ListIterator;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.api.mobile.common.CommonConstants;
import com.coway.trust.biz.eAccounting.vendor.VendorService;
import com.coway.trust.biz.sample.impl.SampleServiceImpl;
import com.coway.trust.util.CommonUtils;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("vendorService")
public class VendorServiceImpl implements VendorService {

	private static final Logger LOGGER = LoggerFactory.getLogger(SampleServiceImpl.class);

	@Value("${app.name}")
	private String appName;

	@Resource(name = "vendorMapper")
	private VendorMapper vendorMapper;

	@Override
	public List<EgovMap> selectVendorGroup() {
		// TODO Auto-generated method stub
		return vendorMapper.selectVendorGroup();
	}

	@Override
	public List<EgovMap> selectBank() {
		// TODO Auto-generated method stub
		return vendorMapper.selectBank();
	}

	@Override
	public List<EgovMap> selectSAPCountry() {
		// TODO Auto-generated method stub
		return vendorMapper.selectSAPCountry();
	}

	@Override
	public List<EgovMap> selectVendorList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return vendorMapper.selectVendorList(params);
	}

	@Override
    public int checkExistNo(String regCompNo) {
        return vendorMapper.checkExistNo(regCompNo);
    }

	@Override
	public int checkExistPaymentType(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return vendorMapper.checkExistPaymentType(params);
	}

	@Override
	public int checkExistBankListNo(Map<String, Object> params) {
		return vendorMapper.checkExistBankListNo(params);
	}

	@Override
	public int checkExistBankAccNo(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return vendorMapper.checkExistBankAccNo(params);
	}

	@Override
	public String selectExistBankAccNo(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return vendorMapper.selectExistBankAccNo(params);
	}

	@Override
	public String selectMemberCode(String memId) {
		return vendorMapper.selectMemberCode(memId);
	}

	@Override
	public String selectNextReqNo() {
		// TODO Auto-generated method stub
		return vendorMapper.selectNextReqNo();
	}

	@Override
	public String selectSameVender(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return vendorMapper.selectSameVender(params);
	}

	@Override
	public String selectNextAppvPrcssNo() {
		// TODO Auto-generated method stub
		return vendorMapper.selectNextAppvPrcssNo();
	}

	@Override
    public EgovMap getFinApprover(Map<String, Object> params) {
        return vendorMapper.getFinApprover(params);
    }

	@Override
    public int checkExistClmNo(String clmNo) {
        return vendorMapper.checkExistClmNo(clmNo);
    }

	@Override
	public EgovMap selectVendorInfo(String reqNo) {
		// TODO Auto-generated method stub
		return vendorMapper.selectVendorInfo(reqNo);
	}

	@Override
	public EgovMap selectVendorInfoMaster(String vendorAccId) {
		// TODO Auto-generated method stub
		return vendorMapper.selectVendorInfoMaster(vendorAccId);
	}

	@Override
	public List<EgovMap> selectAttachList(String atchFileGrpId) {
		// TODO Auto-generated method stub
		return vendorMapper.selectAttachList(atchFileGrpId);
	}

	@Override
	public String checkReqNo(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return vendorMapper.checkReqNo(params);
	}

	@Override
	public void insertVendorInfo(Map<String, Object> params) {
		// TODO Auto-generated method stub

		LOGGER.debug("insertVendorInfo =====================================>>  " + params);

		params.put("vendorGroup", params.get("vendorGroup").toString().trim().toUpperCase());
		params.put("costCentr", params.get("costCentr").toString().trim().toUpperCase());
		params.put("regCompName", params.get("regCompName").toString().trim().toUpperCase());
		params.put("regCompNo", params.get("regCompNo").toString().trim().toUpperCase());
		params.put("street", params.get("street").toString().trim().toUpperCase());
		params.put("houseNo", params.get("houseNo").toString().trim().toUpperCase());
		params.put("postalCode", params.get("postalCode").toString().trim().toUpperCase());
		params.put("city", params.get("city").toString().trim().toUpperCase());
		params.put("vendorCountry", params.get("vendorCountry").toString().trim().toUpperCase());
		params.put("paymentTerms", params.get("paymentTerms").toString().trim().toUpperCase());
		params.put("paymentMethod", params.get("paymentMethod").toString().trim().toUpperCase());
		params.put("others", params.get("others").toString().trim());
		params.put("bankCountry", params.get("bankCountry").toString().trim().toUpperCase());
		params.put("bankAccHolder", params.get("bankAccHolder").toString().trim().toUpperCase());
		params.put("bankList", params.get("bankList").toString().trim().toUpperCase());
		params.put("bankAccNo", params.get("bankAccNo").toString().trim().toUpperCase());
		params.put("bankBranch", params.get("bankBranch").toString().trim().toUpperCase());
		params.put("swiftCode", params.get("swiftCode").toString().trim().toUpperCase());
		params.put("designation", params.get("designation").toString().trim());
		params.put("vendorName", params.get("vendorName").toString().trim().toUpperCase());
		params.put("vendorPhoneNo", params.get("vendorPhoneNo").toString().trim().toUpperCase());
		params.put("vendorEmail", params.get("vendorEmail").toString().trim());
		params.put("vendorType", params.get("vendorType").toString().trim());
		vendorMapper.insertVendorInfo(params);

	}

	@Override
	public void insertApproveManagement(Map<String, Object> params) {
		// TODO Auto-generated method stub
		LOGGER.debug("params =====================================>>  " + params);

		List<Object> apprGridList = (List<Object>) params.get("apprGridList");
		List<Object> newGridList = (List<Object>) params.get("newGridList");

		params.put("appvLineCnt", apprGridList.size());

		LOGGER.debug("insertVendorApproveManagement =====================================>>  " + params);
		vendorMapper.insertApproveManagement(params);

		if (apprGridList.size() > 0) {
		    //webInvoiceMapper.getFinApprover
			Map hm = null;
			List<String> appvLineUserId = new ArrayList<>();

			for (Object map : apprGridList) {
				hm = (HashMap<String, Object>) map;
				hm.put("appvPrcssNo", params.get("appvPrcssNo"));
				hm.put("userId", params.get("userId"));
				hm.put("userName", params.get("userName"));
				LOGGER.debug("insertApproveLineDetail =====================================>>  " + hm);
				// TODO appvLineDetailTable Insert
				vendorMapper.insertApproveLineDetail(hm);

				appvLineUserId.add(hm.get("memCode").toString());
			}

			params.put("clmType", params.get("newReqNo").toString().substring(0, 2));
			EgovMap e1 = vendorMapper.getFinApprover(params);
			String memCode = e1.get("apprMemCode").toString();
			LOGGER.debug("getFinApprover.memCode =====================================>>  " + memCode);
	        memCode = CommonUtils.isEmpty(memCode) ? "0" : memCode;
			if(!appvLineUserId.contains(memCode)) {
			    Map mAppr = new HashMap<String, Object>();
			    mAppr.put("appvPrcssNo", params.get("appvPrcssNo"));
			    mAppr.put("userId", params.get("userId"));
			    mAppr.put("memCode", memCode);
			    LOGGER.debug("insMissAppr =====================================>>  " + mAppr);
			    vendorMapper.insMissAppr(mAppr);
            }

			// 2019-02-19 - LaiKW - Insert notification for request.
			Map ntf = (HashMap<String, Object>) apprGridList.get(0);
			ntf.put("reqNo", params.get("newReqNo"));

			LOGGER.debug("reqNo =====================================>>  " + params.get("newReqNo"));
			EgovMap ntfDtls = new EgovMap();
			ntfDtls = (EgovMap) vendorMapper.getClmDesc(params);
			ntf.put("codeName", ntfDtls.get("codeDesc"));

			ntfDtls = (EgovMap) vendorMapper.getNtfUser(ntf);
			ntf.put("reqstUserId", ntfDtls.get("userName"));
			ntf.put("code", params.get("newReqNo").toString().substring(0, 2));
			ntf.put("appvStus", "R");
			ntf.put("rejctResn", "Pending Approval.");

			LOGGER.debug("ntf =====================================>>  " + ntf);

			vendorMapper.insertNotification(ntf);

		}

		LOGGER.debug("updateAppvPrcssNo =====================================>>  " + params);
		vendorMapper.updateAppvPrcssNo(params);
	}

	@Override
	public List<Object> budgetCheck(Map<String, Object> params) {
		// TODO Auto-generated method stub
		List<Object> list = new ArrayList<Object>();
		List<Object> newGridList = (List<Object>) params.get("newGridList");
		for(int i = 0; i < newGridList.size(); i++) {
			Map<String, Object> data = (Map<String, Object>) newGridList.get(i);
			data.put("year", params.get("year"));
			data.put("month", params.get("month"));
			data.put("costCentr", params.get("costCentr"));
			LOGGER.debug("data =====================================>>  " + data);
			String yN = vendorMapper.budgetCheck(data);
			LOGGER.debug("yN =====================================>>  " + yN);
			if("N".equals(yN)) {
				list.add(data.get("clmSeq"));
			}
		}

		LOGGER.debug("list =====================================>>  " + list);
		LOGGER.debug("list.size() =====================================>>  " + list.size());

		return list;
	}

	@Override
	public void updateVendorInfo(Map<String, Object> params) {
		// TODO Auto-generated method stub
		LOGGER.debug("params =====================================>>  " + params);
		params.put("regCompName", params.get("regCompName").toString().trim().toUpperCase());
		params.put("bankAccHolder", params.get("bankAccHolder").toString().trim().toUpperCase());
		vendorMapper.updateVendorInfo(params);

	}

	@Override
    public void editRejected(Map<String, Object> params) {
        // TODO Auto-generated method stub

        LOGGER.debug("editRejected =====================================>>  " + params);

        EgovMap attachmentDetails = new EgovMap();
        attachmentDetails = (EgovMap) vendorMapper.getAttachmenDetails(params);
        params.put("exFileAtchGrpId", attachmentDetails.get("atchFileGrpId"));
        params.put("exFileAtchId", attachmentDetails.get("atchFileId"));

        // Duplicate File ID
        int newFileAtchGrpId = vendorMapper.getFileAtchGrpId();
        int newFileAtchId = vendorMapper.getFileAtchId();
        params.put("newFileAtchGrpId", newFileAtchGrpId);
        params.put("newFileAtchId", newFileAtchId);

        // Insert SYS0070M
        vendorMapper.insertSYS0070M_ER(params);

        vendorMapper.insertSYS0071D_ER(params);

        // Insert FCM0029D
        vendorMapper.insertRejectM(params);
    }

	@Override
    public void editApproved(Map<String, Object> params) {
        // TODO Auto-generated method stub

        LOGGER.debug("editApproved =====================================>>  " + params);

        EgovMap attachmentDetails = new EgovMap();
        params.put("clmNo", params.get("newReqNo"));
        attachmentDetails = (EgovMap) vendorMapper.getAttachmenDetails(params);
        params.put("exFileAtchGrpId", attachmentDetails.get("atchFileGrpId"));
        params.put("exFileAtchId", attachmentDetails.get("atchFileId"));

        // Duplicate File ID
        int newFileAtchGrpId = vendorMapper.getFileAtchGrpId();
        int newFileAtchId = vendorMapper.getFileAtchId();
        params.put("newFileAtchGrpId", newFileAtchGrpId);
        params.put("newFileAtchId", newFileAtchId);

        // Insert SYS0070M
        vendorMapper.insertSYS0070M_ER(params);

        vendorMapper.insertSYS0071D_ER(params);

        // Insert FCM0029D
        vendorMapper.insertApprovedDraft(params);
    }

	@Override
	public EgovMap existingVendorValidation(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return vendorMapper.existingVendorValidation(params);
	}

	@Override
	public List<EgovMap> selectVendorType(Map<String, Object> params) throws Exception {
		// TODO Auto-generated method stub
		return vendorMapper.selectVendorType();
	}

	@Override
	public List<EgovMap> getAppvExcelInfo(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return vendorMapper.getAppvExcelInfo(params);
	}

}
