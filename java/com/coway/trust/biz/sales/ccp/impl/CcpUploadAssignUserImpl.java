/**
 *
 */
package com.coway.trust.biz.sales.ccp.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.sales.ccp.CcpUploadAssignUserService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;


/**
 * @author HQIT-HUIDING
 * @date Jun 15, 2021
 *
 */
@Service("ccpUploadAssignUserService")
public class CcpUploadAssignUserImpl extends EgovAbstractServiceImpl implements CcpUploadAssignUserService{

	private static final Logger logger = LoggerFactory.getLogger(CcpUploadAssignUserImpl.class);

	@Resource(name="ccpUploadAssignUserMapper")
	private CcpUploadAssignUserMapper uploadMapper;

	@Override
    public int saveCsvUpload(Map<String, Object> master, List<Map<String, Object>> detailList) {

		int masterSeq = uploadMapper.selectNextBatchId();
		master.put("batchId", masterSeq);
		int mResult = uploadMapper.insertUploadAssignUserMst(master); // insert into SAL0290M

		int itmNo = 0;
		for (int count = 0; count <= detailList.size()-1 ; count++){ // row 1 = header
			itmNo++;
			detailList.get(count).put("itmNo", itmNo);
		}

		int size = 1000;
        int page = detailList.size() / size;
        int start;
        int end;

        Map<String, Object> ccpList = new HashMap<>();
        ccpList.put("batchId", masterSeq);

        for (int i = 0; i <= page; i++) {
        	start = i * size;
            end = size;

            if(i == page){
                end = detailList.size();
            }

            ccpList.put("list", detailList.stream().skip(start).limit(end).collect(Collectors.toCollection(ArrayList::new)));
            logger.info("###detailList: " + detailList.toString());

            uploadMapper.insertUploadAssignUserDtl(ccpList); // Insert into SAL0291D
        }

      //CALL PROCEDURE
        uploadMapper.callBatchCcpAssignUser(master); // merge into SAL0102D


        return masterSeq;
	}

	@Override
    public List<EgovMap> selectCcpAssignUserMstList(Map<String, Object> params) {
		return uploadMapper.selectUploadAssignUserList(params);
	}

	@Override
    public List<EgovMap> selectUploadCcpUsertList(Map<String, Object> params) {
		return uploadMapper.selectUploadCcpUsertList(params);
	}

	@Override
    public int updateUploadCcpUsertList(Map<String, Object> params) {
		return uploadMapper.updateUploadCcpUsertList(params);
	}

	@Override
    public int updateCcpCalculationPageUser(Map<String, Object> params) {
		return uploadMapper.updateCcpCalculationPageUser(params);
	}

	@Override
	public EgovMap selectCcpAssignUserDtlList(Map<String, Object> params) {
		List<EgovMap> batchDtlList = uploadMapper.selectUploadAssignUserDtlList(params);
		EgovMap batchInfo = uploadMapper.selectViewHeaderInfo(params);

		batchInfo.put("batchDtlList", batchDtlList);
		return batchInfo;

	}

	@Override
	public EgovMap selectCcpReAssignUserDtlList(Map<String, Object> params) {
		List<EgovMap> batchDtlList = uploadMapper.selectUploadReAssignUserDtlList(params);
		EgovMap batchInfo = uploadMapper.selectViewHeaderInfo(params);

		batchInfo.put("batchDtlList", batchDtlList);
		return batchInfo;

	}

	@Override
	public EgovMap selectCcpReAssignUserDtlListBody(Map<String, Object> params) {
		List<EgovMap> batchDtlListBody = uploadMapper.selectUploadReAssignUserDtlList(params);
		EgovMap batchInfo = uploadMapper.selectViewHeaderInfo(params);
		batchInfo.put("batchDtlListBody", batchDtlListBody);
		return batchInfo;

	}

}
