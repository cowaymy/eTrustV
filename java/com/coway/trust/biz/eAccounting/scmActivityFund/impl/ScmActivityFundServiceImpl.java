package com.coway.trust.biz.eAccounting.scmActivityFund.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.eAccounting.scmActivityFund.ScmActivityFundService;
import com.coway.trust.biz.eAccounting.webInvoice.impl.WebInvoiceMapper;
import com.coway.trust.biz.sample.impl.SampleServiceImpl;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("scmActivityFundService")
public class ScmActivityFundServiceImpl implements ScmActivityFundService {

	private static final Logger LOGGER = LoggerFactory.getLogger(SampleServiceImpl.class);

	@Value("${app.name}")
	private String appName;

	@Autowired
	private MessageSourceAccessor messageSourceAccessor;

	@Resource(name = "scmActivityFundMapper")
	private ScmActivityFundMapper scmActivityFundMapper;

	@Autowired
	private WebInvoiceMapper webInvoiceMapper;

	@Override
	public List<EgovMap> selectScmActivityFundList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return scmActivityFundMapper.selectScmActivityFundList(params);
	}

	@Override
	public List<EgovMap> selectTaxCodeScmActivityFundFlag() {
		// TODO Auto-generated method stub
		return scmActivityFundMapper.selectTaxCodeScmActivityFundFlag();
	}

	@Override
	public void insertScmActivityFundExp(Map<String, Object> params) {
		// TODO Auto-generated method stub
		LOGGER.debug("params =====================================>>  " + params);

		List<Object> gridDataList = (List<Object>) params.get("gridDataList");

		Map<String, Object> masterData = (Map<String, Object>) gridDataList.get(0);

		String clmNo = scmActivityFundMapper.selectNextClmNo();
		params.put("clmNo", clmNo);

		masterData.put("clmNo", clmNo);
		masterData.put("allTotAmt", params.get("allTotAmt"));
		masterData.put("userId", params.get("userId"));
		masterData.put("userName", params.get("userName"));

		LOGGER.debug("masterData =====================================>>  " + masterData);
		scmActivityFundMapper.insertScmActivityFundExp(masterData);

		for(int i = 0; i < gridDataList.size(); i++) {
			Map<String, Object> item = (Map<String, Object>) gridDataList.get(i);
			int clmSeq = scmActivityFundMapper.selectNextClmSeq(clmNo);
			item.put("clmNo", clmNo);
			item.put("clmSeq", clmSeq);
			item.put("userId", params.get("userId"));
			item.put("userName", params.get("userName"));
			LOGGER.debug("insertScmActivityFundExpItem =====================================>>  " + item);
			scmActivityFundMapper.insertScmActivityFundExpItem(item);
		}
	}

	@Override
	public List<EgovMap> selectScmActivityFundItems(String clmNo) {
		// TODO Auto-generated method stub
		return scmActivityFundMapper.selectScmActivityFundItems(clmNo);
	}

	@Override
	public EgovMap selectScmActivityFundInfo(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return scmActivityFundMapper.selectScmActivityFundInfo(params);
	}

	@Override
	public List<EgovMap> selectAttachList(String atchFileGrpId) {
		// TODO Auto-generated method stub
		return scmActivityFundMapper.selectAttachList(atchFileGrpId);
	}

	@Override
	public void updateScmActivityFundExp(Map<String, Object> params) {
		// TODO Auto-generated method stub
		LOGGER.debug("params =====================================>>  " + params);

		// TODO editGridDataList GET
		List<Object> addList = (List<Object>) params.get("add"); // 추가 리스트 얻기
		List<Object> updateList = (List<Object>) params.get("update"); // 수정 리스트 얻기

		if (addList.size() > 0) {
			Map hm = null;
			// biz처리
			for (Object map : addList) {
				hm = (HashMap<String, Object>) map;
				hm.put("clmNo", params.get("clmNo"));
				hm.put("allTotAmt", params.get("allTotAmt"));
				int clmSeq = scmActivityFundMapper.selectNextClmSeq((String) params.get("clmNo"));
				hm.put("clmSeq", clmSeq);
				hm.put("userId", params.get("userId"));
				hm.put("userName", params.get("userName"));
				LOGGER.debug("insertScmActivityFundExpItem =====================================>>  " + hm);
				scmActivityFundMapper.insertScmActivityFundExpItem(hm);
				scmActivityFundMapper.updateScmActivityFundExpTotAmt(hm);
			}
		}
		if (updateList.size() > 0) {
			Map hm = null;
			hm = (Map<String, Object>) updateList.get(0);
			hm.put("clmNo", params.get("clmNo"));
			hm.put("allTotAmt", params.get("allTotAmt"));
			hm.put("userId", params.get("userId"));
			hm.put("userName", params.get("userName"));
			LOGGER.debug("updateScmActivityFundExp =====================================>>  " + hm);
			scmActivityFundMapper.updateScmActivityFundExp(hm);
			for (Object map : updateList) {
				hm = (HashMap<String, Object>) map;
				hm.put("clmNo", params.get("clmNo"));
				hm.put("userId", params.get("userId"));
				hm.put("userName", params.get("userName"));
				LOGGER.debug("updateScmActivityFundExpItem =====================================>>  " + hm);
				// TODO biz처리 (clmNo, clmSeq 값으로 update 처리)
				scmActivityFundMapper.updateScmActivityFundExpItem(hm);
			}
		}


		LOGGER.info("추가 : {}", addList.toString());
		LOGGER.info("수정 : {}", updateList.toString());
	}

	@Override
	public void insertApproveManagement(Map<String, Object> params) {
		// TODO Auto-generated method stub
		LOGGER.debug("params =====================================>>  " + params);

		List<Object> apprGridList = (List<Object>) params.get("apprGridList");
		List<Object> newGridList = (List<Object>) params.get("newGridList");

		params.put("appvLineCnt", apprGridList.size());

		LOGGER.debug("insertApproveManagement =====================================>>  " + params);
		webInvoiceMapper.insertApproveManagement(params);

		if (apprGridList.size() > 0) {
			Map hm = null;

			for (Object map : apprGridList) {
				hm = (HashMap<String, Object>) map;
				hm.put("appvPrcssNo", params.get("appvPrcssNo"));
				hm.put("userId", params.get("userId"));
				hm.put("userName", params.get("userName"));
				LOGGER.debug("insertApproveLineDetail =====================================>>  " + hm);
				// TODO appvLineDetailTable Insert
				webInvoiceMapper.insertApproveLineDetail(hm);
			}
		}

		if (newGridList.size() > 0) {
			Map hm = null;

			// biz처리
			for (Object map : newGridList) {
				hm = (HashMap<String, Object>) map;
				hm.put("appvPrcssNo", params.get("appvPrcssNo"));
				//int appvItmSeq = webInvoiceMapper.selectNextAppvItmSeq(String.valueOf(params.get("appvPrcssNo")));
				//hm.put("appvItmSeq", appvItmSeq);
				hm.put("userId", params.get("userId"));
				hm.put("userName", params.get("userName"));
				LOGGER.debug("insertApproveItems =====================================>>  " + hm);
				// TODO appvLineItemsTable Insert
				scmActivityFundMapper.insertApproveItems(hm);
			}
		}

		LOGGER.debug("updateAppvPrcssNo =====================================>>  " + params);
		// TODO pettyCashReqst table update
		scmActivityFundMapper.updateAppvPrcssNo(params);
	}

	@Override
	public void deleteScmActivityFundExpItem(Map<String, Object> params) {
		// TODO Auto-generated method stub
		scmActivityFundMapper.deleteScmActivityFundExpItem(params);
	}

	@Override
	public void updateScmActivityFundExpTotAmt(Map<String, Object> params) {
		// TODO Auto-generated method stub
		scmActivityFundMapper.updateScmActivityFundExpTotAmt(params);
	}

	@Override
	public List<EgovMap> selectScmActivityFundItemGrp(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return scmActivityFundMapper.selectScmActivityFundItemGrp(params);
	}

	@Override
    public String selectNextClmNo() {
        return scmActivityFundMapper.selectNextClmNo();
    }

	@Override
    public void editRejected(Map<String, Object> params) {
        // TODO Auto-generated method stub

        LOGGER.debug("editRejected =====================================>>  " + params);

        scmActivityFundMapper.insertRejectM(params);

        scmActivityFundMapper.insertRejectD(params);

        List<EgovMap> oldSeq = scmActivityFundMapper.getOldDisClamUn(params);
        for(int i = 0; i < oldSeq.size(); i++) {
            Map<String, Object> oldSeq1 = (Map<String, Object>) oldSeq.get(i);
            String oldClamUn = oldSeq1.get("clamUn").toString();
            LOGGER.debug("oldClamUn :: " + oldClamUn);

            params.put("clmType", "J5");
            EgovMap clamUn = webInvoiceMapper.selectClamUn(params);
            clamUn.put("clmType", "J5");

            webInvoiceMapper.updateClamUn(clamUn);

            LOGGER.debug(clamUn.get("clamUn").toString());
            params.put("oldClamUn", oldClamUn);
            params.put("newClamUn", clamUn.get("clamUn"));
            scmActivityFundMapper.updateExistingClamUn(params);
        }

    }

}
