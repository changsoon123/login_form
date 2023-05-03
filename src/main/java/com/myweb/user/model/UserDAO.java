package com.myweb.user.model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

//DAO(Data Access Object)
//웹 프로그램에서 데이터베이스 CRUD작업이 요구될 때마다
//데이터베이스 접속 및 sql문 실행을 전담하는 비즈니스 로직으로 이루어진 객체
//무분별한 객체 생성을 막기 위해 싱글톤 디자인 패턴으로 구축한다.
public class UserDAO {
	//DATA ACCESS OBJECT
	
	//커넥션 풀의 정보를 담을 변수를 선언.
	private DataSource ds;
	
	
	private UserDAO() {
		//커넥션 풀 정보 불러오기
		try {
			InitialContext ct = new InitialContext();
			ds = (DataSource) ct.lookup("java:comp/env/jdbc/myOracle");
		} catch (NamingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
	}
	
	private static UserDAO dao = new UserDAO();
	
	
	public static UserDAO getInstance() {
		if(dao == null) {
			dao = new UserDAO();
		}
		return dao;
	}
	
	////////////////////////////////////////////////////////
	
	//회원 중복 여부 확인
	
	public boolean confirmId(String id){
		String sql = "SELECT * FROM my_user WHERE user_id=?";
		boolean flag = false;
		try(Connection conn = ds.getConnection();
				PreparedStatement pstmt = conn.prepareStatement(sql);){
			pstmt.setString(1, id);
			ResultSet rs = pstmt.executeQuery();
			if(rs.next()) {
				flag = true;
			}
			
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return flag;
	}

	public void insertUser(UserVO vo) {
		String sql = "INSERT INTO my_user VALUES(?,?,?,?,?)";
		try(Connection conn = ds.getConnection();
				PreparedStatement pstmt = conn.prepareStatement(sql);){
			pstmt.setString(1, vo.getUserId());
			pstmt.setString(2, vo.getUserPw());
			pstmt.setString(3, vo.getUserName());
			pstmt.setString(4, vo.getUserEmail());
			pstmt.setString(5, vo.getUserAddress());
			pstmt.executeUpdate();
			
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
	
}
