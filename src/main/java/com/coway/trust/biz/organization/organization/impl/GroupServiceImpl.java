package com.coway.trust.biz.organization.organization.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.organization.organization.GroupService;
import com.coway.trust.biz.sales.customer.LoyaltyHpService;
import com.coway.trust.biz.sales.customer.impl.LoyaltyHpMapper;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("groupService")
public class GroupServiceImpl implements GroupService {

	private static final Logger LOGGER = LoggerFactory.getLogger(GroupServiceImpl.class);

	@Resource(name = "groupMapper")
	private GroupMapper groupMapper;

	@Override
	public int saveCsvUpload(Map<String, Object> master, List<Map<String, Object>> detailList) {

		int masterSeq = groupMapper.selectNextBatchId();
		master.put("groupBatchId", masterSeq);
		int mResult = groupMapper.insertGroupMst(master); // INSERT INTO ORG0034D

		int size = 1000;
		int page = detailList.size() / size;
		int start;
		int end;

		Map<String, Object> groupList = new HashMap<>();
		groupList.put("groupBatchId", masterSeq);
		for (int i = 0; i <= page; i++) {
			start = i * size;
			end = size;

			if (i == page) {
				end = detailList.size();
			}

			groupList.put("list",
					detailList.stream().skip(start).limit(end).collect(Collectors.toCollection(ArrayList::new)));
			groupMapper.insertGroupDtl(groupList); // INSERT INTO ORG0035D
		}

		return masterSeq;
	}

	@Override
	public List<EgovMap> selectGroupMstList(Map<String, Object> params) {

		return groupMapper.selectGroupMstList(params);
	}

	@Override
	public EgovMap selectGroupInfo(Map<String, Object> params) {
		EgovMap groupBatchInfo = groupMapper.selectGroupMasterInfo(params);
		List<EgovMap> groupBatchDtlInfo = groupMapper.selectGroupDetailInfo(params);

		groupBatchInfo.put("groupBatchItem", groupBatchDtlInfo);
		return groupBatchInfo;
	}

	@Override
	public void callGroupConfirm(Map<String, Object> params) {

		// CALL PROCEDURE
		groupMapper.callBatchGroupUpd(params); // MERGE INTO SAL0271D
	}

	@Override
	public int updGroupReject(Map<String, Object> params) {

		int result = groupMapper.updateGroupMasterStus(params);

		return result;
	}

}
