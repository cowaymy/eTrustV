package com.coway.trust.biz.organization.organization;

import java.util.List;
import java.util.Map;

import com.coway.trust.biz.common.FileVO;
import com.coway.trust.biz.common.type.FileType;

public interface MemberEligibilityApplication {

	void insertMemberEligibilityAttachBiz(List<FileVO> list, FileType type, Map<String, Object> params);
}
