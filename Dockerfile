# --- Stage 1: Build bằng Maven ---
# Sử dụng Maven với Java 11 (khớp với cấu hình pom.xml của bạn)
FROM maven:3.9.6-eclipse-temurin-11 AS build

# Thiết lập thư mục làm việc
WORKDIR /app

# Copy file pom.xml trước để cache các dependency
COPY pom.xml .
# Tải các thư viện (để lần build sau nhanh hơn)
RUN mvn dependency:go-offline

# Copy toàn bộ mã nguồn vào
COPY src ./src

# Build dự án và tạo file WAR (bỏ qua test để nhanh hơn)
RUN mvn clean package -DskipTests

# --- Stage 2: Chạy trên Tomcat 10 (Jakarta EE) ---
FROM tomcat:10.1-jdk11

# Xóa các ứng dụng mặc định của Tomcat để nhẹ hơn (tùy chọn)
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy file WAR từ Stage 1 vào thư mục webapps của Tomcat
# Đổi tên thành 'muahang.war' để đường dẫn truy cập là /muahang
COPY --from=build /app/target/muahang-1.0-SNAPSHOT.war /usr/local/tomcat/webapps/muahang.war

# Mở cổng 8080
EXPOSE 8080

# Khởi chạy Tomcat
CMD ["catalina.sh", "run"]