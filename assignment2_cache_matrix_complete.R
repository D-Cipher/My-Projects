makeCacheMatrix <- function(x = matrix()) {
  transpose <- NULL
  set <- function(y) {
    x <<- y 
    transpose <<- NULL
  }
  get <- function() x
  setinverse <- function(inverse) transpose <<- inverse
  getinverse <- function() transpose 
  list(set = set, get = get, setinverse = setinverse, getinverse = getinverse)
}

cacheSolve <- function(x, ...) {
  transpose <- x$getinverse()
  if(!is.null(transpose)) {
    message("getting cached data")
    return(transpose)
  }
  data <- x$get()
  transpose <- solve(data, ...)
  x$setinverse(transpose)
  transpose
}

data <- matrix(c(1,2,3,4), ncol = 2)
matrix_make <- makeCacheMatrix(data)
matrix_transp <- cacheSolve(matrix_make)
