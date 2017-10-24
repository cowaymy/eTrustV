package com.coway.trust.cmmn.model;

import java.util.ArrayList;

/**
 * T 들의 수정, 추가, 삭제 리스트를 담은 도메인입니다.
 *
 */
public class GridDataSet<T> {

	// 수정 행 리스트
	private ArrayList<T> update;

	// 추가 행 리스트
	private ArrayList<T> add;

	// 삭제 행 리스트
	private ArrayList<T> remove;
	
	private ArrayList<T> all;

	public ArrayList<T> getUpdate() {
		return update;
	}

	public void setUpdate(ArrayList<T> update) {
		this.update = update;
	}

	public ArrayList<T> getAdd() {
		return add;
	}

	public void setAdd(ArrayList<T> add) {
		this.add = add;
	}

	public ArrayList<T> getRemove() {
		return remove;
	}

	public void setRemove(ArrayList<T> remove) {
		this.remove = remove;
	}

	public ArrayList<T> getAll() {
		return all;
	}

	public void setAll(ArrayList<T> all) {
		this.all = all;
	}
	
}
