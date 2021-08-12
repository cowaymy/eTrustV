package com.coway.trust.biz.sales.ownershipTransfer;

import java.util.List;
import java.util.Map;

import com.coway.trust.biz.common.FileVO;
import com.coway.trust.biz.common.type.FileType;

public interface OwnershipTransferApplication {

	void insertOwnershipTransferAttach(List<FileVO> list, FileType type, Map<String, Object> params);

	void updateOwnershipTransferAttach(List<FileVO> list, FileType type, Map<String, Object> params);
}
