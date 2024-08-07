package com.coway.trust.biz.eAccounting.ctDutyAllowance;

import java.util.List;
import java.util.Map;

import com.coway.trust.biz.common.FileVO;
import com.coway.trust.biz.common.type.FileType;

public interface CtDutyAllowanceApplication {

	void insertCtDutyAllowanceAttachBiz(List<FileVO> list, FileType type, Map<String, Object> params);

	void updateCtDutyAllowanceAttachBiz(List<FileVO> list, FileType type, Map<String, Object> params);

	void deleteCtDutyAllowanceAttachBiz(FileType type, Map<String, Object> params);
}
